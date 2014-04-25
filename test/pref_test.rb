require 'test_helper'
require 'yaml'

require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/ext/hash_extensions')
require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/prefs/pref')
require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/prefs/pref_actions/pref_action')
require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/prefs/pref_behaviors/pref_behavior')
require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/prefs/pref_validators/pref_validator')

# Tests for the Prefs class
class TestPref < Test::Unit::TestCase
  def setup
    @prefs_hash = {
      behaviors: [{ name: 'test' }],
      config_key: 'test_prompt',
      config_section: 'app_data',
      default: 'bachya',
      options: ['a', 'b'],
      pre: {
        message: 'Test pre message',
        action: 'test'
      },
      post: {
        message: 'Test post message',
        action: 'test'
      },
      prereqs: [
        { config_section: 'section' },
        { config_value: 'value' }
      ],
      prompt_text: 'Test',
      validators: ['test'],
    }

    CLIUtils::Prefs.register_action(File.join(File.dirname(__FILE__), 'test_files/test_action.rb'))
    CLIUtils::Prefs.register_behavior(File.join(File.dirname(__FILE__), 'test_files/test_behavior.rb'))
    CLIUtils::Prefs.register_validator(File.join(File.dirname(__FILE__), 'test_files/test_validator.rb'))
  end

  def teardown

  end

  def test_initialization
    pref = CLIUtils::Pref.new(@prefs_hash)

    assert_equal(pref.answer, nil)
    assert_equal(pref.behavior_objects[0].class, CLIUtils::TestBehavior.new.class)
    assert_equal(pref.behaviors, [{ name: 'test' }])
    assert_equal(pref.config_key, @prefs_hash[:config_key])
    assert_equal(pref.config_section, @prefs_hash[:config_section])
    assert_equal(pref.default, @prefs_hash[:default])
    assert_equal(pref.last_error_message, nil)
    assert_equal(pref.options, ['a', 'b'])
    assert_equal(pref.post, { message: 'Test post message', action: 'test' })
    assert_equal(pref.pre, { message: 'Test pre message', action: 'test' })
    assert_equal(pref.prereqs, [{ config_section: 'section' }, { config_value: 'value' }])
    assert_equal(pref.validator_objects[0].class, CLIUtils::TestValidator.new.class)
    assert_equal(pref.validators, ['test'])
  end

  def test_action
    require File.join(File.dirname(__FILE__), 'test_files/test_action.rb')
    a = CLIUtils::TestAction.new
    assert_output("here\n") { a.run }
  end

  def test_behavior
    require File.join(File.dirname(__FILE__), 'test_files/test_behavior.rb')
    b = CLIUtils::TestBehavior.new
    assert_equal(b.evaluate('test'), 'test_behavior: test')
  end

  def test_validator
    require File.join(File.dirname(__FILE__), 'test_files/test_validator.rb')
    v = CLIUtils::TestValidator.new
    v.validate('bachya')

    assert_equal(v.is_valid, true)
    assert_equal(v.message, "String did not equal 'bachya': bachya")
  end
end