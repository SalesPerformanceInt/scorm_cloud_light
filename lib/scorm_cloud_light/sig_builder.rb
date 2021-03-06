# frozen_string_literal: true

require 'digest'

module ScormCloudLight
  # SigBuilder generates the proper signature required to validate SCORM Cloud API calls.
  module SigBuilder
    class << self
      def call(url_params, secret_key)
        build_params_string(url_params)
          .yield_self { |params_string| secret_key.dup.concat(params_string) }
          .yield_self { |raw_sig_string| Digest::MD5.hexdigest(raw_sig_string) }
      end

      private

      def build_params_string(params)
        params.keys
              .sort { |a, b| a.to_s.downcase <=> b.to_s.downcase }
              .map { |key| "#{key}#{params[key]}" }
              .join
      end
    end
  end
end
