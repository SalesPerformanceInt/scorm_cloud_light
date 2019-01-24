module ScormCloudLight
  module URLBuilder
    class << self

      def call(method_params, scorm_credentials)
        url_params = build_url_params(method_params, scorm_credentials)
        build_up_url(url_params, scorm_credentials)
      end

      private

      def build_url_params(method_params, scorm_credentials)
        method_params
          .merge(method: "rustici.#{method_params[:method]}")
          .merge(ts: build_timestamp, appid: scorm_credentials[:app_id])
      end

      def build_up_url(params, scorm_credentials)
        scorm_credentials[:api_base_url].dup
          .concat('/api?')
          .concat(encode_url_params(params))
          .concat('&sig=')
          .concat(ScormCloudLight::SigBuilder.call(params, scorm_credentials))
      end

      def encode_url_params(params)
        base_params = params.slice(:method, :appid)
        arg_params = params.except(:method, :appid)
        encode(base_params)
          .concat('&')
          .concat(encode(arg_params))
      end

      def encode(params)
        URI.encode_www_form(params)
      end

      def build_timestamp
        Time.current.utc.strftime('%Y%m%d%H%M%S')
      end
    end
  end
end
