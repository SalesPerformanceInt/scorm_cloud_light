# frozen_string_literal: true

module ScormCloudLight
  # URLBuilder generates the proper URL for a request
  module URLBuilder
    class << self
      def call(method_params, app_id, secret_key, scorm_base_url)
        url_params = build_url_params(method_params, app_id.freeze)
        build_up_url(url_params, secret_key.freeze, scorm_base_url.freeze)
      end

      private

      def build_url_params(method_params, app_id)
        method_params
          .merge(method: "rustici.#{method_params[:method]}")
          .merge(ts: build_timestamp, appid: app_id)
      end

      def build_up_url(url_params, secret_key, scorm_base_url)
        scorm_base_url.dup
                      .concat('/api?')
                      .concat(encode_url_params(url_params))
                      .concat('&sig=')
                      .concat(SigBuilder.call(url_params, secret_key))
      end

      def encode_url_params(url_params)
        base_params = url_params.slice(:method, :appid)
        arg_params  = url_params.slice(*(url_params.keys - base_params.keys))
        encode(base_params)
          .concat('&')
          .concat(encode(arg_params))
      end

      def encode(params)
        URI.encode_www_form(params)
      end

      def build_timestamp
        Time.now.utc.strftime('%Y%m%d%H%M%S')
      end
    end
  end
end
