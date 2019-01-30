require "spec_helper"

RSpec.describe ScormCloudLight::APIDispatcher do

  let(:url) { "https://cloud.scorm.com/fake_method_request" }

  it "raises an error if the verb is not POST or GET" do
    expect { ScormCloudLight::APIDispatcher.call("NOPE", url) }.to raise_error(ScormCloudLight::InvalidHttpVerb)
  end

  context "GET requests" do
    before(:each) do
      stub_request(:get, url)
        .with(headers: {
          "Accept"=>"*/*",
          "Accept-Encoding"=>"gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Host"=>"cloud.scorm.com",
          "User-Agent"=>"Ruby"
        })
        .to_return(status: 200, body: "hello", headers: {})
    end

    it "calls Net::HTTP.get and returns 200" do
      response = ScormCloudLight::APIDispatcher.call("GET", url)
      expect(response.code).to eq "200"
      expect(response.body).to eq "hello"
    end
  end

  context "POST requests" do
    before(:each) do
      stub_request(:post, url)
        .with(headers: {
          "Accept"=>"*/*",
          "Accept-Encoding"=>"gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Host"=>"cloud.scorm.com",
          "User-Agent"=>"Ruby"
        })
        .to_return(status: 200, body: "hello", headers: {})
    end

    it "calls Net::HTTP.post and returns 200 for a POST verb" do
      response = ScormCloudLight::APIDispatcher.call("POST", url)
      expect(response.code).to eq "200"
      expect(response.body).to eq "hello"
    end

    it "calls Net::HTTP.post and returns 200 if no verb given" do
      response = ScormCloudLight::APIDispatcher.call(nil, url)
      expect(response.code).to eq "200"
      expect(response.body).to eq "hello"
    end
  end
end
