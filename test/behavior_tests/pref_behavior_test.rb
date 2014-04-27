require 'test_helper'

require File.join(File.dirname(__FILE__), '..', '..', 'test/test_files/test_behavior_empty')

# Tests for the Configurator class
class TestPrefBehavior < Test::Unit::TestCase
  def test_direct_call
    b = CLIUtils::TestBehaviorEmpty.new
    m = '`evaluate` method not implemented on caller: CLIUtils::TestBehaviorEmpty'
    assert_raise_with_message(RuntimeError, m) { b.evaluate('bachya') }
  end
end
