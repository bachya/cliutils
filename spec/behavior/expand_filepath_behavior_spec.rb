require_relative '../spec_helper'
require 'cliutils/messaging'
require 'cliutils/prefs/pref_behaviors/pref_behavior'
require 'cliutils/prefs/pref_behaviors/expand_filepath_behavior'

describe CLIUtils::ExpandFilepathBehavior do
  it 'runs File.expand_path on its input' do
    b = CLIUtils::ExpandFilepathBehavior.new
    expect(b.evaluate('~/test')).to eq("#{ ENV['HOME'] }/test")
  end
end