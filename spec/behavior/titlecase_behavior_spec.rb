require 'cliutils/messaging'
require 'cliutils/prefs/pref_behaviors/pref_behavior'
require 'cliutils/prefs/pref_behaviors/titlecase_behavior'

describe CLIUtils::TitlecaseBehavior do
  it 'titlecases its input' do
    b = CLIUtils::TitlecaseBehavior.new
    expect(b.evaluate('my sentence is here')).to eq('My Sentence Is Here')
  end
end