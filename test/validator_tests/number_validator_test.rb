require 'test_helper'

require File.join(File.dirname(__FILE__), '..', '..', 'lib/cliutils/prefs/pref_validators/number_validator')

class TestNumberValidator < Test::Unit::TestCase
  def test_valid
    v = CLIUtils::NumberValidator.new
    v.validate('1234.112')

    assert_equal(v.is_valid, 0)
    assert_equal(v.message, 'Response is not a number: 1234.112')
  end

  def test_invalid
    v = CLIUtils::NumberValidator.new
    v.validate('abcdefg')

    assert_not_equal(v.is_valid, 0)
    assert_equal(v.message, 'Response is not a number: abcdefg')
  end
end
