require_relative '../spec_helper'
require 'cliutils/messaging'
require 'cliutils/prefs/pref_validators/pref_validator'
require 'cliutils/prefs/pref_validators/non_nil_validator'

describe CLIUtils::NonNilValidator do
  it 'confirms that its input is non-nil' do
    v = CLIUtils::NonNilValidator.new
    v.validate('bachya')
    expect(v.is_valid).to be_true
    expect(v.message).to eq('Nil text not allowed')
  end

  it 'confirms that its input is not non-nil' do
    v = CLIUtils::NonNilValidator.new
    v.validate('')
    expect(v.is_valid).to_not be_true
    expect(v.message).to eq('Nil text not allowed')

    v.validate(nil)
    expect(v.is_valid).to_not be_true
    expect(v.message).to eq('Nil text not allowed')
  end
end