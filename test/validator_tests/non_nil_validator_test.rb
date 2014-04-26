require 'test_helper'

require File.join(File.dirname(__FILE__), '..', '..', 'lib/cliutils/prefs/pref_validators/non_nil_validator')

# Tests for the Configurator class
class TestNonNilValidator < Test::Unit::TestCase
  def test_valid
    v = CLIUtils::NonNilValidator.new
    v.validate('asdasdasd')

    assert_equal(v.is_valid, true)
    assert_equal(v.message, 'Nil text not allowed')
  end

  def test_invalid_1
    v = CLIUtils::NonNilValidator.new
    v.validate('')

    assert_equal(v.is_valid, false)
    assert_equal(v.message, 'Nil text not allowed')
  end

  def test_invalid_2
    v = CLIUtils::NonNilValidator.new
    v.validate(nil)

    assert_equal(v.is_valid, false)
    assert_equal(v.message, 'Nil text not allowed')
  end
end
