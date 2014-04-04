require 'test/unit'
require 'yaml'

require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/ext/Hash+Extensions')
require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/prefs')
require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/prefs/pref')

class TestPrefs < Test::Unit::TestCase
  def setup
    @prefs_arr = [{:prompt=>"Where is your SSH public key located?", :config_key=>"pub_key", :config_section=>"personal_info", :behaviors=>["local_filepath"]}]
    @prefs_hash = {:prompts=>@prefs_arr}
    
    @prefs_filepath = '/tmp/prefstest.yaml'
    FileUtils.cp(File.join(File.dirname(__FILE__), '..', 'test/test_files/prefstest.yaml'), @prefs_filepath)
  end

  def teardown
    FileUtils.rm(@prefs_filepath) if File.exists?(@prefs_filepath)
  end

  def test_file_creation
    p = CLIUtils::Prefs.new(@prefs_filepath)
    prefs = YAML::load_file(@prefs_filepath).deep_symbolize_keys

    assert_equal(prefs[:prompts].map { |p| CLIUtils::Pref.new(p) }, p.prefs)
  end

  def test_array_creation
    p = CLIUtils::Prefs.new(@prefs_arr)
    prefs = @prefs_hash.deep_symbolize_keys
  
    assert_equal(prefs[:prompts].map { |p| CLIUtils::Pref.new(p) }, p.prefs)    
  end

  def test_hash_creation
    p = CLIUtils::Prefs.new(@prefs_hash)
    prefs = @prefs_hash.deep_symbolize_keys
  
    assert_equal(prefs[:prompts].map { |p| CLIUtils::Pref.new(p) }, p.prefs)
  end
end
