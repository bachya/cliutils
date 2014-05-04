require_relative '../spec_helper'
require 'cliutils/messaging'
require 'cliutils/prefs/pref_validators/pref_validator'
require 'cliutils/prefs/pref_validators/datetime_validator'

describe CLIUtils::DatetimeValidator do
  it 'confirms that its input is a datetime' do
    v = CLIUtils::DatetimeValidator.new
    v.validate('2014-02-01 12:34 PM')
    expect(v.is_valid).to be_true
    expect(v.message).to eq('Response is not a datetime: 2014-02-01 12:34 PM')
  end

  it 'confirms that its input is not a datetime' do
    v = CLIUtils::DatetimeValidator.new
    v.validate('!@&^')
    expect(v.is_valid).to_not be_true
    expect(v.message).to eq('Response is not a datetime: !@&^')
  end
end