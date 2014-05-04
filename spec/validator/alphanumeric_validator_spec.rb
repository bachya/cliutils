require_relative '../spec_helper'
require 'cliutils/messaging'
require 'cliutils/prefs/pref_validators/pref_validator'
require 'cliutils/prefs/pref_validators/alphanumeric_validator'

describe CLIUtils::AlphanumericValidator do
  it 'confirms that its input is alphanumeric' do
    v = CLIUtils::AlphanumericValidator.new
    v.validate('bachya91238 ')
    expect(v.is_valid).to be_true
    expect(v.message).to eq('Response is not alphanumeric: bachya91238 ')
  end

  it 'confirms that its input is not alphanumeric' do
    v = CLIUtils::AlphanumericValidator.new
    v.validate('!@&^')
    expect(v.is_valid).to_not be_true
    expect(v.message).to eq('Response is not alphanumeric: !@&^')
  end
end