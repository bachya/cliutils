require 'fileutils'
require 'test/unit'
require 'yaml'

require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/ext/Hash+Extensions')
require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/prefs')

class TestPrefs < Test::Unit::TestCase
  def setup
    @prefs_arr = [{:prompt=>"What is the hostname of your DD-WRT router?", :default=>"192.168.1.1", :key=>"hostname", :section=>"ssh_info"}, {:prompt=>"What is the SSH username of your DD-WRT router?", :default=>"root", :key=>"username", :section=>"ssh_info"}, {:prompt=>"What SSH port does your DD-WRT router use?", :default=>22, :key=>"port", :section=>"ssh_info"}, {:prompt=>"How do you use password or key authentication?", :default=>"password", :key=>"auth_method", :section=>"ssh_info", :options=>["password", "key"]}, {:prompt=>"Where is your key located?", :default=>"~/.ssh", :key=>"key_location", :section=>"ssh_info", :requirements=>[{:key=>"auth_method", :value=>"key"}]}, {:prompt=>"What is your password?", :key=>"password", :section=>"ssh_info", :requirements=>[{:key=>"auth_method", :value=>"password"}]}]
    
    @prefs_filepath = '/tmp/prefstest.yaml'
    FileUtils.cp(File.join(File.dirname(__FILE__), '..', 'test/test_files/prefstest.yaml'), @prefs_filepath)
  end

  def teardown
    FileUtils.rm(@prefs_filepath) if File.exists?(@prefs_filepath)
  end

  def test_file_creation
    p = CLIUtils::Prefs.new(@prefs_filepath)
    assert_equal(YAML::load_file(@prefs_filepath).deep_symbolize_keys!, p.prefs)
  end

  def test_hash_creation
    p = CLIUtils::Prefs.new(@prefs_arr)
    assert_equal({:prompts => @prefs_arr}.deep_symbolize_keys!, p.prefs)
  end
end
