require_relative '../spec_helper'
require 'cliutils/messaging'
require 'cliutils/prefs/pref_actions/pref_action'
require File.join(File.dirname(__FILE__), '..', '..', 'support/test_action_empty')

describe CLIUtils::TestActionEmpty do
  it 'raises an exception if `run` is not implemented' do
    m = '`run` method not implemented on caller: CLIUtils::TestActionEmpty'
    expect { CLIUtils::TestActionEmpty.new.run }.to raise_error(RuntimeError, m)
  end
end