require 'test_helper'

require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/ext/string_extensions')

class TestStringExtensions < Test::Unit::TestCase
  def test_custom_colors
    assert_output("\e[34mtest\e[0m") { print 'test'.blue }
    assert_output("\e[36mtest\e[0m") { print 'test'.cyan }
    assert_output("\e[32mtest\e[0m") { print 'test'.green }
    assert_output("\e[35mtest\e[0m") { print 'test'.purple }
    assert_output("\e[31mtest\e[0m") { print 'test'.red }
    assert_output("\e[37mtest\e[0m") { print 'test'.white }
    assert_output("\e[33mtest\e[0m") { print 'test'.yellow }
  end

  def test_colorize
    assert_output("\e[35;42mtest\e[0m") { print 'test'.colorize('35;42') }
  end

  def test_camelize
    assert_output('TestString') { print 'test_string'.camelize }
  end

  def test_snakify
    assert_output('test_string') { print 'TestString'.snakify }
  end
end
