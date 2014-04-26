require 'test_helper'

require File.join(File.dirname(__FILE__), '..', '..', 'lib/cliutils/prefs/pref_validators/alphanumeric_validator')

# Tests for the Configurator class
class TestAlphanumericValidator < Test::Unit::TestCase
  def test_valid
    v = CLIUtils::AlphanumericValidator.new
    v.validate('bachya91238 ')

    assert_equal(v.is_valid, 0)
    assert_equal(v.message, 'Response is not alphanumeric: bachya91238 ')
  end

  def test_invalid
    v = CLIUtils::AlphanumericValidator.new
    v.validate('!@&^')

    assert_not_equal(v.is_valid, 0)
    assert_equal(v.message, 'Response is not alphanumeric: !@&^')
  end
end
