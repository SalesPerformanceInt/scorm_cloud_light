module ScormCloudLight
  module SigBuilder
    class << self

      def call(method_params, scorm_credentials)
        build_params_string(method_params)
          .yield_self { |params_string| scorm_credentials[:secret_key].dup.concat(params_string) }
          .yield_self { |raw_sig_string| Digest::MD5.hexdigest(raw_sig_string) }
      end

      private

      def build_params_string(params)
        params.keys
          .sort { |a, b| a.to_s.downcase <=> b.to_s.downcase }
          .map { |key| "#{key.to_s}#{params[key]}" }
          .join
      end
    end
  end
end
