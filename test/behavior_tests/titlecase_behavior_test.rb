require 'test_helper'

require File.join(File.dirname(__FILE__), '..', '..', 'lib/cliutils/prefs/pref_behaviors/titlecase_behavior')

# Tests for the Configurator class
class TestTitlecaseBehavior < Test::Unit::TestCase
  def test_evaluation
    v = CLIUtils::TitlecaseBehavior.new
    assert_equal(v.evaluate('my sentence is here'), 'My Sentence Is Here')
  end
end
