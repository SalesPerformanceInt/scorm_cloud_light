# frozen_string_literal: true

require 'net/http'
require 'openssl'

module ScormCloudLight
  # ApiDispatcher is responsible for sending requests to SCORM Cloud
  module ApiDispatcher
    class << self
      def call(http_verb, url)
        verb    = select_verb(http_verb)
        uri     = URI(url)
        request = build_request(verb, uri)

        dispatch_request(uri, request)
      end

      private

      def select_verb(http_verb)
        verb = http_verb || 'POST'
        raise InvalidHttpVerb unless %w[POST GET].include?(verb)

        verb
      end

      def build_request(verb, uri)
        if verb == 'GET'
          Net::HTTP::Get.new(uri)
        else
          Net::HTTP::Post.new(uri)
        end
      end

      def dispatch_request(uri, request)
        Net::HTTP.start(
          uri.host, uri.port, use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_PEER
        ) { |http| http.request(request) }
      end
    end
  end
end
