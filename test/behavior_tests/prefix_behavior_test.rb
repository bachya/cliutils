require 'test_helper'

require File.join(File.dirname(__FILE__), '..', '..', 'lib/cliutils/prefs/pref_behaviors/prefix_behavior')

# Tests for the Configurator class
class TestPrefixBehavior < Test::Unit::TestCase
  def test_evaluation
    v = CLIUtils::PrefixBehavior.new
    v.parameters = { prefix: 'test: ' }
    assert_equal(v.evaluate('bachya'), 'test: bachya')
  end
end
