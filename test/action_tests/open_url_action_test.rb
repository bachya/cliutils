require 'test_helper'

require File.join(File.dirname(__FILE__), '..', '..', 'lib/cliutils/prefs/pref_actions/open_url_action')

# Tests for the Configurator class
class TestOpenUrlAction < Test::Unit::TestCase
  def test_run
    a = CLIUtils::OpenUrlAction.new
    a.parameters = { url: 'http://www.google.com' }
    assert_output() { a.run }
  end
end
