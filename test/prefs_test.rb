require 'test_helper'
require 'yaml'

require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/ext/hash_extensions')
require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/prefs')
require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/prefs/pref')

# Tests for the Prefs class
class TestPrefs < Test::Unit::TestCase
  def setup
    @prefs_arr = [
      {
        'prompt_text' => 'Batman or Superman?',
        'default' => 'Batman',
        'config_key' => 'superhero',
        'config_section' => 'personal_info'
      },
      {
        'prompt_text' => 'Do you feel smart for preferring Batman?',
        'default' => 'Y',
        'config_key' => 'batman_answer',
        'config_section' => 'personal_info',
        'prereqs' => [
          {
            'config_key' => 'superhero',
            'config_value' => 'Batman'
          }
        ]
      },
      {
        'prompt_text' => 'Why do you prefer Superman?!',
        'default' => 'No clue',
        'config_key' => 'superman_answer',
        'config_section' => 'personal_info',
        'prereqs' => [
          {
            'config_key' => 'superhero',
            'config_value' => 'Superman'
          }
        ]
      }
    ]

    @prefs_hash = {:prompts=>@prefs_arr}
    @prefs_filepath = '/tmp/prefstest.yaml'
    FileUtils.cp(File.join(File.dirname(__FILE__), '..', 'test/test_files/prefstest.yaml'), @prefs_filepath)
  end

  def teardown
    FileUtils.rm(@prefs_filepath) if File.file?(@prefs_filepath)
  end

  def test_file_creation
    p = CLIUtils::Prefs.new(@prefs_filepath)
    prefs = YAML::load_file(@prefs_filepath).deep_symbolize_keys
    assert_equal(prefs[:prompts].map { |p| CLIUtils::Pref.new(p) }, p.prompts)
  end

  def test_bad_file_creation
    m = 'Invalid configuration file: asd'
    assert_raise_with_message(RuntimeError, m) { p = CLIUtils::Prefs.new('asd') }
  end

  def test_array_creation
    p = CLIUtils::Prefs.new(@prefs_arr)
    prefs = @prefs_hash.deep_symbolize_keys
    assert_equal(prefs[:prompts].map { |p| CLIUtils::Pref.new(p) }, p.prompts)
  end

  def test_hash_creation
    p = CLIUtils::Prefs.new(@prefs_hash)
    prefs = @prefs_hash.deep_symbolize_keys
    assert_equal(prefs[:prompts].map { |p| CLIUtils::Pref.new(p) }, p.prompts)
  end

  def test_invalid_type_creation
    m = 'Invalid configuration data'
    assert_raise_with_message(RuntimeError, m) { p = CLIUtils::Prefs.new(123) }
  end

  def test_register
    CLIUtils::Prefs.register_action(File.join(File.dirname(__FILE__), 'test_files/test_action.rb'))
    assert_equal(CLIUtils::Prefs.registered_actions.key?(:Test), true)
    assert_equal(CLIUtils::Prefs.registered_actions[:Test][:class], 'TestAction')
    assert_equal(CLIUtils::Prefs.registered_actions[:Test][:path], File.join(File.dirname(__FILE__), 'test_files/test_action.rb'))

    CLIUtils::Prefs.register_behavior(File.join(File.dirname(__FILE__), 'test_files/test_behavior.rb'))
    assert_equal(CLIUtils::Prefs.registered_behaviors.key?(:Test), true)
    assert_equal(CLIUtils::Prefs.registered_behaviors[:Test][:class], 'TestBehavior')
    assert_equal(CLIUtils::Prefs.registered_behaviors[:Test][:path], File.join(File.dirname(__FILE__), 'test_files/test_behavior.rb'))

    CLIUtils::Prefs.register_validator(File.join(File.dirname(__FILE__), 'test_files/test_validator.rb'))
    assert_equal(CLIUtils::Prefs.registered_validators.key?(:Test), true)
    assert_equal(CLIUtils::Prefs.registered_validators[:Test][:class], 'TestValidator')
    assert_equal(CLIUtils::Prefs.registered_validators[:Test][:path], File.join(File.dirname(__FILE__), 'test_files/test_validator.rb'))
  end

  def test_bad_registration
    m = 'Registration failed because of unknown filepath: bachya.rb'
    assert_raise_with_message(RuntimeError, m) { CLIUtils::Prefs.register_action('bachya.rb') }
    assert_raise_with_message(RuntimeError, m) { CLIUtils::Prefs.register_behavior('bachya.rb') }
    assert_raise_with_message(RuntimeError, m) { CLIUtils::Prefs.register_validator('bachya.rb') }
  end

  def test_deregister
    CLIUtils::Prefs.register_action(File.join(File.dirname(__FILE__), 'test_files/test_action.rb'))
    CLIUtils::Prefs.deregister_action(:Test)
    assert_equal(CLIUtils::Prefs.registered_actions.key?(:Test), false)

    CLIUtils::Prefs.register_behavior(File.join(File.dirname(__FILE__), 'test_files/test_behavior.rb'))
    CLIUtils::Prefs.deregister_behavior(:Test)
    assert_equal(CLIUtils::Prefs.registered_behaviors.key?(:Test), false)

    CLIUtils::Prefs.register_validator(File.join(File.dirname(__FILE__), 'test_files/test_validator.rb'))
    CLIUtils::Prefs.deregister_validator(:Test)
    assert_equal(CLIUtils::Prefs.registered_validators.key?(:Test), false)
  end
end
