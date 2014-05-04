require_relative '../spec_helper'
require 'cliutils/messaging'
require 'cliutils/prefs/pref_behaviors/pref_behavior'
require File.join(File.dirname(__FILE__), '..', '..', 'support/test_behavior_empty')

describe CLIUtils::TestBehaviorEmpty do
  it 'raises an exception if `evaluate` is not implemented' do
    m = '`evaluate` method not implemented on caller: CLIUtils::TestBehaviorEmpty'
    expect { CLIUtils::TestBehaviorEmpty.new.evaluate('') }.to raise_error(RuntimeError, m)
  end
end