require 'test_helper'

require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/configurator')
require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/configuration')

# Tests for the Configurator class
class TestConfiguration < Test::Unit::TestCase
  include CLIUtils::Configuration

  def setup
    @config_path = '/tmp/test.config'
    @expected_config_data = {
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
  end

  def teardown
    FileUtils.rm(@config_path) if File.file?(@config_path)
  end

  def test_before_loading
    assert_raise RuntimeError do
      configuration
    end
  end

  def test_empty_configuration
    load_configuration(@config_path)
    assert_equal(configuration.class, CLIUtils::Configurator)
    assert_equal(configuration.config_path, @config_path)
    assert_equal(configuration.data, {})
  end

  def test_existing_configuration
    FileUtils.cp(File.join(File.dirname(__FILE__), '..', 'test/test_files/configuration.yaml'), @config_path)
    load_configuration(@config_path)
    assert_equal(configuration.class, CLIUtils::Configurator)
    assert_equal(configuration.config_path, @config_path)
    assert_equal(configuration.data, @expected_config_data)
  end
end
