require 'test/unit'
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
    FileUtils.rm(@prefs_filepath) if File.exist?(@prefs_filepath)
  end

  def test_file_creation
    p = CLIUtils::Prefs.new(@prefs_filepath)
    prefs = YAML::load_file(@prefs_filepath).deep_symbolize_keys

    assert_equal(prefs[:prompts].map { |p| CLIUtils::Pref.new(p) }, p.prompts)
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
end
