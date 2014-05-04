require_relative '../spec_helper'
require 'cliutils/messaging'
require 'cliutils/prefs/pref_behaviors/pref_behavior'
require 'cliutils/prefs/pref_behaviors/lowercase_behavior'

describe CLIUtils::LowercaseBehavior do
  it 'lowercases its input' do
    b = CLIUtils::LowercaseBehavior.new
    expect(b.evaluate('BaChYa')).to eq('bachya')
  end
end