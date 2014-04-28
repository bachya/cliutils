require 'test_helper'

require File.join(File.dirname(__FILE__), '..', '..', 'lib/cliutils/prefs/pref_behaviors/lowercase_behavior')

class TestLowercaseBehavior < Test::Unit::TestCase
  def test_evaluation
    v = CLIUtils::LowercaseBehavior.new
    assert_equal(v.evaluate('BaChYa'), 'bachya')
  end
end
