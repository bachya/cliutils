require 'test_helper'

require File.join(File.dirname(__FILE__), '..', '..', 'lib/cliutils/prefs/pref_behaviors/suffix_behavior')

class TestSuffixBehavior < Test::Unit::TestCase
  def test_evaluation
    v = CLIUtils::SuffixBehavior.new
    v.parameters = { suffix: ' - signing off!' }
    assert_equal(v.evaluate('bachya'), 'bachya - signing off!')
  end
end
