require "spec_helper"

RSpec.describe ScormCloudLight::SigBuilder do

  let(:url_params) {{
    method: "rustici.debug.fakeMethod",
    dog: "Spots",
    cat: "Kitty",
    timestamp: "20180424201037",
    appid: "hello"
  }}

  let(:secret) { "ABCDEF".freeze }

  it "builds a sig correctly" do
    expect(ScormCloudLight::SigBuilder.call(url_params, secret)).to eq "3c0eebaed8ffc0545f9f8b9f14c35442"
  end
end
