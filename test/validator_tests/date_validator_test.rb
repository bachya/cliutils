require 'test_helper'

require File.join(File.dirname(__FILE__), '..', '..', 'lib/cliutils/prefs/pref_validators/date_validator')

# Tests for the Configurator class
class TestDateValidator < Test::Unit::TestCase
  def test_valid
    v = CLIUtils::DateValidator.new
    v.validate('2014-02-01')

    assert_equal(v.is_valid, true)
    assert_equal(v.message, 'Response is not a date: 2014-02-01')
  end

  def test_invalid
    v = CLIUtils::DateValidator.new
    v.validate('!@&^')

    assert_equal(v.is_valid, false)
    assert_equal(v.message, 'Response is not a date: !@&^')
  end
end
