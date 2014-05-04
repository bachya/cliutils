require_relative '../spec_helper'
require 'cliutils/messaging'
require 'cliutils/prefs/pref_validators/pref_validator'
require 'cliutils/prefs/pref_validators/time_validator'

describe CLIUtils::TimeValidator do
  it 'confirms that its input is a time' do
    v = CLIUtils::TimeValidator.new
    v.validate('12:43 AM')
    expect(v.is_valid).to be_true
    expect(v.message).to eq('Response is not a time: 12:43 AM')
  end

  it 'confirms that its input is not a time' do
    v = CLIUtils::TimeValidator.new
    v.validate('!@&^')
    expect(v.is_valid).to_not be_true
    expect(v.message).to eq('Response is not a time: !@&^')
  end
end