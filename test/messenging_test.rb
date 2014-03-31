require 'logger'
require 'test/unit'

require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/ext/String+Extensions')
require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/pretty-io')
require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/logger-delegator')
require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/messenging')

class TestMessenging < Test::Unit::TestCase
  include CLIUtils::Messenging
  
  def setup
    @file1path = '/tmp/file1.txt'
  end

  def teardown
    FileUtils.rm(@file1path) if File.exists?(@file1path)
  end
  
  def test_stdout_output
    assert_output('# This is error'.red + "\n") { messenger.send(:error, 'This is error') }
    assert_output('# This is info'.blue + "\n") { messenger.send(:info, 'This is info') }
    assert_output('---> This is section'.purple + "\n") { messenger.send(:section, 'This is section') }
    assert_output('# This is success'.green + "\n") { messenger.send(:success, 'This is success') }
    assert_output('# This is warn'.yellow + "\n") { messenger.send(:warn, 'This is warn') }
  end
  
  def test_wrapping
    CLIUtils::PrettyIO.wrap_char_limit = 35
    
    long_str = 'This is a really long string that should wrap itself at some point, okay?'
    expected_str = long_str.gsub(/\n/, ' ').gsub(/(.{1,#{CLIUtils::PrettyIO.wrap_char_limit - 2}})(\s+|$)/, "# \\1\n").strip
    assert_output(expected_str.blue + "\n") { messenger.send(:info, long_str) }
  end

  def test_attach_detach
    file_logger = Logger.new(@file1path)
    file_logger.formatter = proc do |severity, datetime, progname, msg|
      "#{ severity }: #{ msg }\n"
    end
    
    messenger.attach(FILE: file_logger)
    messenger.send(:info, 'Info test')
    messenger.send(:error, 'Error test')
    messenger.detach(:FILE)
    messenger.send(:warn, 'Warn test')
    
    File.open(@file1path, 'r') do |f|
      assert_output("INFO: Info test\nERROR: Error test\n") { puts f.read.lines.to_a[1..-1].join }
    end
  end
end
