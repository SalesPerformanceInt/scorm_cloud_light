require "scorm_cloud_light/api_dispatcher"
require "scorm_cloud_light/exceptions"
require "scorm_cloud_light/sig_builder"
require "scorm_cloud_light/url_builder"
require "scorm_cloud_light/version"

module ScormCloudLight

  class Client
    
    def initialize(app_id, secret_key, scorm_base_url)
      @app_id = app_id
      @secret_key = secret_key
      @scorm_base_url = scorm_base_url
    end
  
    def dispatch(method_params)
      ScormCloudLight.dispatch(method_params, @app_id, @secret_key, @scorm_base_url)
    end
  end

  class << self

    def dispatch(method_params, app_id, secret_key, scorm_base_url)
      url = build_url(method_params, app_id, secret_key, scorm_base_url)
      dispatch_request(method_params, url)
    end
  
    private
  
    def build_url(method_params, app_id, secret_key, scorm_base_url)
      builder_params = get_builder_params(method_params)
      ScormCloudLight::URLBuilder.call(builder_params, app_id, secret_key, scorm_base_url)
    end

    def get_builder_params(method_params)
      method_params.slice(*(method_params.keys - [:http_verb]))
    end

    def dispatch_request(method_params, url)
      ScormCloudLight::ApiDispatcher.call(method_params[:http_verb], url)
    end
  end
end
