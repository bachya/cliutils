require_relative '../spec_helper'
require 'cliutils/messaging'
require 'cliutils/prefs/pref_validators/pref_validator'
require 'cliutils/prefs/pref_validators/url_validator'

describe CLIUtils::UrlValidator do
  it 'confirms that its input is a URL' do
    v = CLIUtils::UrlValidator.new
    v.validate('http://www.google.com')
    expect(v.is_valid).to be_true
    expect(v.message).to eq('Response is not a URL: http://www.google.com')
  end

  it 'confirms that its input is not a URL' do
    v = CLIUtils::UrlValidator.new
    v.validate('!@&^')
    expect(v.is_valid).to_not be_true
    expect(v.message).to eq('Response is not a URL: !@&^')
  end
end