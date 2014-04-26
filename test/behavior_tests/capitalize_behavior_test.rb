require 'test_helper'

require File.join(File.dirname(__FILE__), '..', '..', 'lib/cliutils/prefs/pref_behaviors/capitalize_behavior')

# Tests for the Configurator class
class TestCapitalizeBehavior < Test::Unit::TestCase
  def test_evaluation
    v = CLIUtils::CapitalizeBehavior.new
    assert_equal(v.evaluate('bachya'), 'Bachya')
  end
end
