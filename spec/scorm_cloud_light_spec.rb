require "spec_helper"

RSpec.describe ScormCloudLight do

  let(:app_id) { "appy123456" }
  let(:secret_key) { "ABCDEF" }
  let(:scorm_base_url) { "https://cloud.scorm.com" }

  let(:method_params) {{
    method: "debug.fakeMethod",
    dog: "Peanut",
    cat: "Roxie",
  }}
  let(:fake_url) { "https://cloud.scorm.com/fake_method_request" }

  before(:each) do
    allow(ScormCloudLight::URLBuilder).to receive(:call)
      .with(anything, app_id, secret_key, scorm_base_url)
      .and_return(fake_url)
    
    response_double = instance_double(Net::HTTPResponse)
    allow(ScormCloudLight::ApiDispatcher).to receive(:call)
      .with(anything, fake_url)
      .and_return(response_double)

    stub_request(:post, fake_url)
  end

  describe "Client class instance dispatch method execution" do
    let(:client) { ScormCloudLight::Client.new(app_id, secret_key, scorm_base_url) }

    it "calls the Client class dispatch method properly" do
      expect(ScormCloudLight).to receive(:dispatch)
        .with(method_params, app_id, secret_key, scorm_base_url)
      client.dispatch(method_params)
    end
  end

  describe "Core class dispatch method execution" do
    
    context "with an explicit http_verb" do
      let(:post_dispatch) { ScormCloudLight.dispatch(
        method_params.merge(http_verb: "POST"), app_id, secret_key, scorm_base_url) 
      }

      it "calls the URLBuilder correctly" do
        expect(ScormCloudLight::URLBuilder).to receive(:call)
          .with(method_params.slice(:method, :dog, :cat), app_id, secret_key, scorm_base_url)  
        post_dispatch
      end
  
      it "calls the ApiDispatcher correctly" do
        expect(ScormCloudLight::ApiDispatcher).to receive(:call)
          .with("POST", fake_url)  
        post_dispatch
      end
    end

    context "WITHOUT an explicit http_verb" do
      let(:dispatch) { ScormCloudLight.dispatch(method_params, app_id, secret_key, scorm_base_url) }

      it "calls the URLBuilder correctly" do
        expect(ScormCloudLight::URLBuilder).to receive(:call)
          .with(method_params, app_id, secret_key, scorm_base_url)  
        dispatch
      end
  
      it "calls the ApiDispatcher correctly" do
        expect(ScormCloudLight::ApiDispatcher).to receive(:call)
          .with(nil, fake_url)  
        dispatch
      end
    end
  end
end
