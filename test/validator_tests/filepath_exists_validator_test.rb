require 'test_helper'

require File.join(File.dirname(__FILE__), '..', '..', 'lib/cliutils/prefs/pref_validators/filepath_exists_validator')

class TestFilepathExistsValidator < Test::Unit::TestCase
  def test_valid
    v = CLIUtils::FilepathExistsValidator.new
    v.validate('/tmp')

    assert_equal(v.is_valid, true)
    assert_equal(v.message, 'Path does not exist locally: /tmp')
  end

  def test_invalid
    v = CLIUtils::FilepathExistsValidator.new
    v.validate('asdasd')

    assert_equal(v.is_valid, false)
    assert_equal(v.message, 'Path does not exist locally: asdasd')
  end
end
