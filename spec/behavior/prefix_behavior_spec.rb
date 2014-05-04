require_relative '../spec_helper'
require 'cliutils/messaging'
require 'cliutils/prefs/pref_behaviors/pref_behavior'
require 'cliutils/prefs/pref_behaviors/prefix_behavior'

describe CLIUtils::PrefixBehavior do
  it 'prefixes its input' do
    b = CLIUtils::PrefixBehavior.new
    b.parameters = { prefix: 'Starting up: ' }
    expect(b.evaluate('bachya')).to eq('Starting up: bachya')
  end
end