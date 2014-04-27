require 'test_helper'

require File.join(File.dirname(__FILE__), '..', '..', 'test/test_files/test_action_empty')

# Tests for the Configurator class
class TestPrefAction < Test::Unit::TestCase
  def test_direct_call
    a = CLIUtils::TestActionEmpty.new
    m = '`run` method not implemented on caller: CLIUtils::TestActionEmpty'
    assert_raise_with_message(RuntimeError, m) { a.run }
  end
end
