require 'test_helper'

require File.join(File.dirname(__FILE__), '..', '..', 'lib/cliutils/prefs/pref_validators/datetime_validator')

class TestDatetimeValidator < Test::Unit::TestCase
  def test_valid
    v = CLIUtils::DatetimeValidator.new
    v.validate('2014-02-01 12:34 PM')

    assert_equal(v.is_valid, true)
    assert_equal(v.message, 'Response is not a datetime: 2014-02-01 12:34 PM')
  end

  def test_invalid
    v = CLIUtils::DatetimeValidator.new
    v.validate('!@&^')

    assert_equal(v.is_valid, false)
    assert_equal(v.message, 'Response is not a datetime: !@&^')
  end
end
