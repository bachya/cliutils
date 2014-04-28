require 'test_helper'

require File.join(File.dirname(__FILE__), '..', '..', 'lib/cliutils/prefs/pref_actions/open_url_action')

class TestOpenUrlAction < Test::Unit::TestCase
  def test_run
    a = CLIUtils::OpenUrlAction.new
    a.parameters = { url: 'http://www.google.com' }
    assert_output() { a.run }
  end

  def test_invalid_run
    a = CLIUtils::OpenUrlAction.new
    a.parameters = { url: 'bachya' }

    exception = assert_raise(RuntimeError) { a.run }
    assert_equal("Failed to open URL: No application found to handle 'bachya'", exception.message)
  end
end
