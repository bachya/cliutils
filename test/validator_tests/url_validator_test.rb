require 'test_helper'

require File.join(File.dirname(__FILE__), '..', '..', 'lib/cliutils/prefs/pref_validators/url_validator')

# Tests for the Configurator class
class TestUrlValidator < Test::Unit::TestCase
  def test_valid
    v = CLIUtils::UrlValidator.new
    v.validate('http://www.google.com')

    assert_equal(v.is_valid, 0)
    assert_equal(v.message, 'Response is not a url: http://www.google.com')
  end

  def test_invalid
    v = CLIUtils::UrlValidator.new
    v.validate('basdahd0283123')

    assert_not_equal(v.is_valid, 0)
    assert_equal(v.message, 'Response is not a url: basdahd0283123')
  end
end
