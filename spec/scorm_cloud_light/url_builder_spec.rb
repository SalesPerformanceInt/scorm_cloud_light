require 'spec_helper'
require 'rspec/expectations'

RSpec::Matchers.define :match_ts_value do |expected|
  match do |actual|
    actual[0,12] == Time.now.utc.strftime('%Y%m%d%H%M') &&
    actual.length == 14
  end
end

RSpec.describe ScormCloudLight::URLBuilder do

  let(:app_id) { "appy123456".freeze }
  let(:secret_key) { "ABCDEF".freeze }
  let(:scorm_base_url) { "https://cloud.scorm.com".freeze }

  let(:method_params) {{
    method: 'debug.fakeMethod',
    dog: 'Peanut',
    cat: 'Roxie'
  }}

  let(:expected_url_params) {
    method_params
     .merge(method: "rustici.#{method_params[:method]}")
     .merge(appid: app_id, ts: match_ts_value)
  }

  let(:builder_call) { ScormCloudLight::URLBuilder.call(method_params, app_id, secret_key, scorm_base_url) }

  before(:each) do
    allow(ScormCloudLight::SigBuilder).to receive(:call).with(
      expected_url_params, secret_key
    ).and_return('siggy')
  end

  it 'calls the SigBuilder correctly' do
    expect(ScormCloudLight::SigBuilder).to receive(:call).with(expected_url_params, secret_key)
    builder_call
  end

  it 'builds a URL correctly' do
    expect(builder_call[0,101]).to eq(
      'https://cloud.scorm.com/api?method=rustici.debug.fakeMethod&appid=appy123456&dog=Peanut&cat=Roxie&ts='
    )
    expect(builder_call[101,14]).to match_ts_value
    expect(builder_call[-10..-1]).to eq '&sig=siggy'
  end
end
