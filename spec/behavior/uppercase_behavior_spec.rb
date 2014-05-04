require_relative '../spec_helper'
require 'cliutils/messaging'
require 'cliutils/prefs/pref_behaviors/pref_behavior'
require 'cliutils/prefs/pref_behaviors/uppercase_behavior'

describe CLIUtils::UppercaseBehavior do
  it 'uppercases its input' do
    b = CLIUtils::UppercaseBehavior.new
    expect(b.evaluate('bachya')).to eq('BACHYA')
  end
end