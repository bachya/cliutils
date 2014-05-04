require_relative '../spec_helper'
require 'cliutils/messaging'
require 'cliutils/prefs/pref_validators/pref_validator'
require 'cliutils/prefs/pref_validators/number_validator'

describe CLIUtils::NumberValidator do
  it 'confirms that its input is a number' do
    v = CLIUtils::NumberValidator.new
    v.validate('12345.678')
    expect(v.is_valid).to be_true
    expect(v.message).to eq('Response is not a number: 12345.678')
  end

  it 'confirms that its input is not a number' do
    v = CLIUtils::NumberValidator.new
    v.validate('bachya')
    expect(v.is_valid).to_not be_true
    expect(v.message).to eq('Response is not a number: bachya')
  end
end