require_relative '../spec_helper'
require 'cliutils/messaging'
require 'cliutils/prefs/pref_behaviors/pref_behavior'
require 'cliutils/prefs/pref_behaviors/capitalize_behavior'

describe CLIUtils::CapitalizeBehavior do
  it 'capitalizes its input' do
    b = CLIUtils::CapitalizeBehavior.new
    expect(b.evaluate('bachya')).to eq('Bachya')
  end
end