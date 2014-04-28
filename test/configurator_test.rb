require 'fileutils'
require 'test_helper'

require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/ext/hash_extensions')
require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/configurator')

class TestConfigurator < Test::Unit::TestCase
  def setup
    @config_path = '/tmp/test.config'
    FileUtils.cp(File.join(File.dirname(__FILE__), 'test_files/configuration.yaml'), @config_path)
    @config_data = {
      my_app: {
        config_location: '/Users/bob/.my-app-config',
        log_level: 'WARN',
        version: '1.0.0'
      },
      user_data: {
        username: 'bob',
        age: 45
      }
    }
    @config = CLIUtils::Configurator.new(@config_path)

    @prefs_filepath = '/tmp/prefstest.yaml'
    FileUtils.cp(File.join(File.dirname(__FILE__), '..', 'test/test_files/prefstest.yaml'), @prefs_filepath)
  end

  def teardown
    FileUtils.rm(@config_path) if File.file?(@config_path)
  end

  def test_add_section
    @config.add_section(:test)
    assert_equal(@config.data, @config_data.merge!(test: {}))
  end

  def test_add_existing_section
    @config.add_section(:test)
    exception = assert_raise(RuntimeError) { @config.add_section(:test) }
    assert_equal('Section already exists: test', exception.message)
  end

  def test_backup
    backup_path = @config.backup
    assert_equal("#{ @config_path }-#{ Time.now.to_i }", backup_path)
  end

  def test_delete_section
    @config.add_section(:test)
    @config.add_section(:test2)
    @config.delete_section(:test)
    assert_equal(@config.data, @config_data.merge!(test2: {}))
  end

  def test_delete_nonexistent_section
    exception = assert_raise(RuntimeError) { @config.delete_section(:test) }
    assert_equal('Cannot delete nonexistent section: test', exception.message)
  end

  def test_accessing
    @config.add_section(:test)
    @config.data[:test].merge!(name: 'Bob')
    assert_equal(@config.test, name: 'Bob')
  end

  def test_reset
    @config.add_section(:test)
    @config.data[:test].merge!(name: 'Bob')
    @config.reset
    assert_equal(@config.data, {})
  end

  def test_save
    @config.add_section(:section1)
    @config.section1.merge!(a: 'test', b: 'test')
    @config.save

    File.open(@config_path, 'r') do |f|
      h = YAML.load(f.read).deep_symbolize_keys
      assert_equal(@config.data, h)
    end
  end

  def test_compare_version
    @config.add_section(:app_data)
    @config.app_data.merge!({ VERSION: '1.0.0' })

    @config.current_version = @config.app_data['VERSION']
    @config.last_version = '1.0.8'

    @config.compare_version do |c, l|
      assert_output('true') { print 'true' }
    end
  end

  def test_ingest_prefs
    prefs = CLIUtils::Prefs.new(@prefs_filepath)
    @config.ingest_prefs(prefs)
    data = {
      my_app: {
        config_location: '/Users/bob/.my-app-config',
        log_level: 'WARN',
        version: '1.0.0'
      },
      user_data: {
        username: 'bob',
        age: 45
      },
      app_data: {
        test_prompt: nil
      }
    }
    assert_equal(@config.data, data)
  end

  def test_ingest_bad_prefs
    exception = assert_raise(RuntimeError) { @config.ingest_prefs(123) }
    assert_equal('Invaid Prefs class', exception.message)
  end
end
