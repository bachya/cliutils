require 'test_helper'

require File.join(File.dirname(__FILE__), '..', '..', 'lib/cliutils/prefs/pref_validators/alphabetic_validator')

# Tests for the Configurator class
class TestAlphabeticValidator < Test::Unit::TestCase
  def test_valid
    v = CLIUtils::AlphabeticValidator.new
    v.validate('bachya')

    assert_equal(v.is_valid, 0)
    assert_equal(v.message, 'Response is not alphabetic: bachya')
  end

  def test_invalid
    v = CLIUtils::AlphabeticValidator.new
    v.validate('12345')

    assert_not_equal(v.is_valid, 0)
    assert_equal(v.message, 'Response is not alphabetic: 12345')
  end
end
