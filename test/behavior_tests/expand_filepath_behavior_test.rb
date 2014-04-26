require 'test_helper'

require File.join(File.dirname(__FILE__), '..', '..', 'lib/cliutils/prefs/pref_behaviors/expand_filepath_behavior')

# Tests for the Configurator class
class TestExpandFilepathBehavior < Test::Unit::TestCase
  def test_evaluation
    v = CLIUtils::ExpandFilepathBehavior.new
    assert_equal(v.evaluate('~/test'), "#{ ENV['HOME'] }/test")
  end
end
