require 'test_helper'

require File.join(File.dirname(__FILE__), '..', '..', 'test/test_files/test_action_empty')

class TestPrefAction < Test::Unit::TestCase
  def test_direct_call
    a = CLIUtils::TestActionEmpty.new

    exception = assert_raise(RuntimeError) { a.run }
    assert_equal('`run` method not implemented on caller: CLIUtils::TestActionEmpty', exception.message)
  end
end
