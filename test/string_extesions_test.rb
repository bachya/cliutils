require 'test/unit'

require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/ext/String+Extensions')

class TestHashExtensions < Test::Unit::TestCase
  def test_custom_colors
    assert_output("\e[34mtest\e[0m\n") { puts 'test'.blue }
    assert_output("\e[36mtest\e[0m\n") { puts 'test'.cyan }
    assert_output("\e[32mtest\e[0m\n") { puts 'test'.green }
    assert_output("\e[35mtest\e[0m\n") { puts 'test'.purple }
    assert_output("\e[31mtest\e[0m\n") { puts 'test'.red }
    assert_output("\e[33mtest\e[0m\n") { puts 'test'.yellow }
  end
end