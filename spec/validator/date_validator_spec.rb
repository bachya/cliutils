require_relative '../spec_helper'
require 'cliutils/messaging'
require 'cliutils/prefs/pref_validators/pref_validator'
require 'cliutils/prefs/pref_validators/date_validator'

describe CLIUtils::DateValidator do
  it 'confirms that its input is a date' do
    v = CLIUtils::DateValidator.new
    v.validate('2014-02-01')
    expect(v.is_valid).to be_true
    expect(v.message).to eq('Response is not a date: 2014-02-01')
  end

  it 'confirms that its input is not a date' do
    v = CLIUtils::DateValidator.new
    v.validate('!@&^')
    expect(v.is_valid).to_not be_true
    expect(v.message).to eq('Response is not a date: !@&^')
  end
end