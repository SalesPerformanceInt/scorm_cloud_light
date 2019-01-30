require 'net/http'
require 'openssl'

module ScormCloudLight
  module ApiDispatcher
    class << self

      def call(http_verb, url)
        verb = get_verb(http_verb)
        uri = URI(url)
        request = build_request(verb, uri)
        dispatch_request(uri, request)
      end

      private

      def get_verb(http_verb)
        verb = http_verb || 'POST'
        raise InvalidHttpVerb unless ['POST', 'GET'].include?(verb)
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
