require_relative '../spec_helper'
require 'cliutils/messaging'
require 'cliutils/prefs/pref_validators/pref_validator'
require File.join(File.dirname(__FILE__), '..', '..', 'support/test_validator_empty')

describe CLIUtils::TestValidatorEmpty do
  it 'raises an exception if `validate` is not implemented' do
    m = '`validate` method not implemented on caller: CLIUtils::TestValidatorEmpty'
    expect { CLIUtils::TestValidatorEmpty.new.validate('') }.to raise_error(RuntimeError, m)
  end
end