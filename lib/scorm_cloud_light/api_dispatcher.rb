require 'net/http'

module ScormCloudLight
  module APIDispatcher
    class << self

      def call(method_params, scorm_credentials)
        verb = method_params[:verb] || 'POST'
        raise "Invalid Verb" unless ['POST', 'GET'].include?(verb)
        build_and_dispatch_request(verb, method_params, scorm_credentials)
      end

      private

      def build_and_dispatch_request(verb, method_params, scorm_credentials)
        uri = URI(ScormCloudLight::URLBuilder.call(method_params.except(:verb), scorm_credentials))
        request = build_request(verb, uri)
        dispatch_request(uri, request)
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
