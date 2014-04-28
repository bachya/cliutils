require 'test_helper'

require File.join(File.dirname(__FILE__), '..', '..', 'lib/cliutils/prefs/pref_behaviors/uppercase_behavior')

class TestUppercaseBehavior < Test::Unit::TestCase
  def test_evaluation
    v = CLIUtils::UppercaseBehavior.new
    assert_equal(v.evaluate('bachya'), 'BACHYA')
  end
end
