require 'fileutils'
require 'test/unit'

require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/configurator')

# Tests for the Configurator class
class TestConfigurator < Test::Unit::TestCase
  def setup
    @config_path = '/tmp/test.config'
    @config = CLIUtils::Configurator.new(@config_path)
  end

  def teardown
    FileUtils.rm(@config_path) if File.exist?(@config_path)
  end

  def test_add_section
    @config.add_section(:test)
    assert_equal(@config.data, test: {})
  end

  def test_delete_section
    @config.add_section(:test)
    @config.add_section(:test2)
    @config.delete_section(:test)
    assert_equal(@config.data, test2: {})
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
      assert_output("---\nsection1:\n  a: test\n  b: test\n") { puts f.read }
    end
  end
end
