require 'test_helper'

require File.join(File.dirname(__FILE__), '..', '..', 'lib/cliutils/prefs/pref_validators/time_validator')

class TestTimeValidator < Test::Unit::TestCase
  def test_valid
    v = CLIUtils::TimeValidator.new
    v.validate('12:43 AM')

    assert_equal(v.is_valid, 0)
    assert_equal(v.message, 'Response is not a time: 12:43 AM')
  end

  def test_invalid
    v = CLIUtils::TimeValidator.new
    v.validate('bzzzp')

    assert_not_equal(v.is_valid, 0)
    assert_equal(v.message, 'Response is not a time: bzzzp')
  end
end
