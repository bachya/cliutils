require_relative '../spec_helper'
require 'cliutils/messaging'
require 'cliutils/prefs/pref_actions/pref_action'
require 'cliutils/prefs/pref_actions/open_url_action'

describe CLIUtils::OpenUrlAction do
  it 'opens a website with the specified parameter' do
    a = CLIUtils::OpenUrlAction.new
    a.parameters = { url: 'http://www.google.com' }
    expect(Launchy).to receive(:open).with('http://www.google.com')
    a.run
  end

  it 'throws an exception with a bad URL' do
    a = CLIUtils::OpenUrlAction.new
    a.parameters = { url: 'bachya' }
    m = "Failed to open URL: No application found to handle 'bachya'"
    expect { a.run }.to raise_error(RuntimeError, m)
  end
end