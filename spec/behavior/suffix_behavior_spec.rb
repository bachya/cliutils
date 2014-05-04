require_relative '../spec_helper'
require 'cliutils/messaging'
require 'cliutils/prefs/pref_behaviors/pref_behavior'
require 'cliutils/prefs/pref_behaviors/suffix_behavior'

describe CLIUtils::SuffixBehavior do
  it 'prefixes its input' do
    b = CLIUtils::SuffixBehavior.new
    b.parameters = { suffix: ' - signing off!' }
    expect(b.evaluate('bachya')).to eq('bachya - signing off!')
  end
end