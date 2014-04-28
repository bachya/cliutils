require 'test_helper'

require File.join(File.dirname(__FILE__), '..', '..', 'test/test_files/test_behavior_empty')

# Tests for the Configurator class
class TestPrefBehavior < Test::Unit::TestCase
  def test_direct_call
    b = CLIUtils::TestBehaviorEmpty.new

    exception = assert_raise(RuntimeError) { b.evaluate(123) }
    assert_equal('`evaluate` method not implemented on caller: CLIUtils::TestBehaviorEmpty', exception.message)
  end
end
