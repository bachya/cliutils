require_relative '../spec_helper'
require 'cliutils/messaging'
require 'cliutils/prefs/pref_validators/pref_validator'
require 'cliutils/prefs/pref_validators/alphabetic_validator'

describe CLIUtils::AlphabeticValidator do
  it 'confirms that its input is alphabetic' do
    v = CLIUtils::AlphabeticValidator.new
    v.validate('bachya')
    expect(v.is_valid).to be_true
    expect(v.message).to eq('Response is not alphabetic: bachya')
  end

  it 'confirms that its input is not alphabetic' do
    v = CLIUtils::AlphabeticValidator.new
    v.validate('12345')
    expect(v.is_valid).to_not be_true
    expect(v.message).to eq('Response is not alphabetic: 12345')
  end
end