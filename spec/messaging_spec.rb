require_relative 'spec_helper'
require 'cliutils/ext/logger_extensions'
require 'cliutils/ext/string_extensions'
require 'cliutils/messaging'
require 'cliutils/pretty_io'

describe CLIUtils::Messaging do
  include CLIUtils::Messaging

  it 'gives a set of standard message formats' do
    out = capture_stdout { messenger.error('error') }
    expect(out).to eq('# error'.red + "\n")

    out = capture_stdout { messenger.info('info') }
    expect(out).to eq('# info'.blue + "\n")

    out = capture_stdout { messenger.section('section') }
    expect(out).to eq('---> section'.purple + "\n")

    out = capture_stdout { messenger.success('success') }
    expect(out).to eq('# success'.green + "\n")

    out = capture_stdout { messenger.warn('warn') }
    expect(out).to eq('# warn'.yellow + "\n")
  end

  it 'wraps strings' do
    CLIUtils::PrettyIO.wrap = true
    CLIUtils::PrettyIO.wrap_char_limit = 35
    long_str = 'This is a really long string that should wrap itself at ' \
    'some point, okay?'
    expected_str = "# This is a really long string that\n# should wrap " \
    "itself at some point,\n# okay?"

    out = capture_stdout { messenger.info(long_str) }
    expect(out).to eq(expected_str.blue + "\n")

    CLIUtils::PrettyIO.wrap = false
    out = capture_stdout { messenger.info(long_str) }
    expect(out).to eq("# #{ long_str }".blue + "\n")
  end

  let(:output_filepath) { '/tmp/file1.txt' }
  it 'attaches and detaches various Logger instances' do
    file_logger = Logger.new(output_filepath)
    file_logger.formatter = proc do |severity, datetime, progname, msg|
      "#{ severity }: #{ msg }\n"
    end

    out = capture_stdout do
      messenger.attach(FILE: file_logger)
      messenger.debug('Debug test')
      messenger.info('Info test')
      messenger.error('Error test')
      messenger.detach(:FILE)
      messenger.warn('Warn test')
    end

    File.open(output_filepath, 'r') do |f|
      file_contents = f.read.lines.to_a[1..-1].join
      m = "DEBUG: Debug test\nINFO: Info test\nERROR: Error test\n"
      expect(file_contents).to eq(m)
    end
    FileUtils.rm(output_filepath)
  end

  it 'raises an exception when attempting to detach an unknown target' do
    m = 'Cannot detach invalid target: bachya'
    expect { messenger.detach(:bachya) }.to raise_error(RuntimeError, m)
  end

  it 'allows users to deliver answers to prompts' do
    Readline.stub(:readline).and_return('Yes', '')
    Readline.stub(:completion_proc=).and_return("\t")
    expect(messenger.prompt('Do you like cheese?', 'No')).to eq('Yes')
    expect(messenger.prompt('Do you like cheese?', 'No')).to eq('No')
    expect(messenger.prompt('Do you like cheese?', '')).to eq('')
  end

  it 'warns about deprecated methods' do
    out = capture_stdout { messenger.info_block('test') }
    s = 'As of 2.2.0, `info_block` is deprecated and nonfunctioning.'
    expect(out).to eq("# #{ s }".yellow + "\n")
  end

  it 'outputs a useful ASCII color chart' do
    s = "----------------------------------------------------------------\nESC[0;Foreground;Background\n\e[0;30;40m 30;40  \e[0;30;41m 30;41  \e[0;30;42m 30;42  \e[0;30;43m 30;43  \e[0;30;44m 30;44  \e[0;30;45m 30;45  \e[0;30;46m 30;46  \e[0;30;47m 30;47  \e[0m\n\e[0;31;40m 31;40  \e[0;31;41m 31;41  \e[0;31;42m 31;42  \e[0;31;43m 31;43  \e[0;31;44m 31;44  \e[0;31;45m 31;45  \e[0;31;46m 31;46  \e[0;31;47m 31;47  \e[0m\n\e[0;32;40m 32;40  \e[0;32;41m 32;41  \e[0;32;42m 32;42  \e[0;32;43m 32;43  \e[0;32;44m 32;44  \e[0;32;45m 32;45  \e[0;32;46m 32;46  \e[0;32;47m 32;47  \e[0m\n\e[0;33;40m 33;40  \e[0;33;41m 33;41  \e[0;33;42m 33;42  \e[0;33;43m 33;43  \e[0;33;44m 33;44  \e[0;33;45m 33;45  \e[0;33;46m 33;46  \e[0;33;47m 33;47  \e[0m\n\e[0;34;40m 34;40  \e[0;34;41m 34;41  \e[0;34;42m 34;42  \e[0;34;43m 34;43  \e[0;34;44m 34;44  \e[0;34;45m 34;45  \e[0;34;46m 34;46  \e[0;34;47m 34;47  \e[0m\n\e[0;35;40m 35;40  \e[0;35;41m 35;41  \e[0;35;42m 35;42  \e[0;35;43m 35;43  \e[0;35;44m 35;44  \e[0;35;45m 35;45  \e[0;35;46m 35;46  \e[0;35;47m 35;47  \e[0m\n\e[0;36;40m 36;40  \e[0;36;41m 36;41  \e[0;36;42m 36;42  \e[0;36;43m 36;43  \e[0;36;44m 36;44  \e[0;36;45m 36;45  \e[0;36;46m 36;46  \e[0;36;47m 36;47  \e[0m\n\e[0;37;40m 37;40  \e[0;37;41m 37;41  \e[0;37;42m 37;42  \e[0;37;43m 37;43  \e[0;37;44m 37;44  \e[0;37;45m 37;45  \e[0;37;46m 37;46  \e[0;37;47m 37;47  \e[0m\n----------------------------------------------------------------\nESC[1;Foreground;Background\n\e[1;30;40m 30;40  \e[1;30;41m 30;41  \e[1;30;42m 30;42  \e[1;30;43m 30;43  \e[1;30;44m 30;44  \e[1;30;45m 30;45  \e[1;30;46m 30;46  \e[1;30;47m 30;47  \e[0m\n\e[1;31;40m 31;40  \e[1;31;41m 31;41  \e[1;31;42m 31;42  \e[1;31;43m 31;43  \e[1;31;44m 31;44  \e[1;31;45m 31;45  \e[1;31;46m 31;46  \e[1;31;47m 31;47  \e[0m\n\e[1;32;40m 32;40  \e[1;32;41m 32;41  \e[1;32;42m 32;42  \e[1;32;43m 32;43  \e[1;32;44m 32;44  \e[1;32;45m 32;45  \e[1;32;46m 32;46  \e[1;32;47m 32;47  \e[0m\n\e[1;33;40m 33;40  \e[1;33;41m 33;41  \e[1;33;42m 33;42  \e[1;33;43m 33;43  \e[1;33;44m 33;44  \e[1;33;45m 33;45  \e[1;33;46m 33;46  \e[1;33;47m 33;47  \e[0m\n\e[1;34;40m 34;40  \e[1;34;41m 34;41  \e[1;34;42m 34;42  \e[1;34;43m 34;43  \e[1;34;44m 34;44  \e[1;34;45m 34;45  \e[1;34;46m 34;46  \e[1;34;47m 34;47  \e[0m\n\e[1;35;40m 35;40  \e[1;35;41m 35;41  \e[1;35;42m 35;42  \e[1;35;43m 35;43  \e[1;35;44m 35;44  \e[1;35;45m 35;45  \e[1;35;46m 35;46  \e[1;35;47m 35;47  \e[0m\n\e[1;36;40m 36;40  \e[1;36;41m 36;41  \e[1;36;42m 36;42  \e[1;36;43m 36;43  \e[1;36;44m 36;44  \e[1;36;45m 36;45  \e[1;36;46m 36;46  \e[1;36;47m 36;47  \e[0m\n\e[1;37;40m 37;40  \e[1;37;41m 37;41  \e[1;37;42m 37;42  \e[1;37;43m 37;43  \e[1;37;44m 37;44  \e[1;37;45m 37;45  \e[1;37;46m 37;46  \e[1;37;47m 37;47  \e[0m\n----------------------------------------------------------------\nESC[4;Foreground;Background\n\e[4;30;40m 30;40  \e[4;30;41m 30;41  \e[4;30;42m 30;42  \e[4;30;43m 30;43  \e[4;30;44m 30;44  \e[4;30;45m 30;45  \e[4;30;46m 30;46  \e[4;30;47m 30;47  \e[0m\n\e[4;31;40m 31;40  \e[4;31;41m 31;41  \e[4;31;42m 31;42  \e[4;31;43m 31;43  \e[4;31;44m 31;44  \e[4;31;45m 31;45  \e[4;31;46m 31;46  \e[4;31;47m 31;47  \e[0m\n\e[4;32;40m 32;40  \e[4;32;41m 32;41  \e[4;32;42m 32;42  \e[4;32;43m 32;43  \e[4;32;44m 32;44  \e[4;32;45m 32;45  \e[4;32;46m 32;46  \e[4;32;47m 32;47  \e[0m\n\e[4;33;40m 33;40  \e[4;33;41m 33;41  \e[4;33;42m 33;42  \e[4;33;43m 33;43  \e[4;33;44m 33;44  \e[4;33;45m 33;45  \e[4;33;46m 33;46  \e[4;33;47m 33;47  \e[0m\n\e[4;34;40m 34;40  \e[4;34;41m 34;41  \e[4;34;42m 34;42  \e[4;34;43m 34;43  \e[4;34;44m 34;44  \e[4;34;45m 34;45  \e[4;34;46m 34;46  \e[4;34;47m 34;47  \e[0m\n\e[4;35;40m 35;40  \e[4;35;41m 35;41  \e[4;35;42m 35;42  \e[4;35;43m 35;43  \e[4;35;44m 35;44  \e[4;35;45m 35;45  \e[4;35;46m 35;46  \e[4;35;47m 35;47  \e[0m\n\e[4;36;40m 36;40  \e[4;36;41m 36;41  \e[4;36;42m 36;42  \e[4;36;43m 36;43  \e[4;36;44m 36;44  \e[4;36;45m 36;45  \e[4;36;46m 36;46  \e[4;36;47m 36;47  \e[0m\n\e[4;37;40m 37;40  \e[4;37;41m 37;41  \e[4;37;42m 37;42  \e[4;37;43m 37;43  \e[4;37;44m 37;44  \e[4;37;45m 37;45  \e[4;37;46m 37;46  \e[4;37;47m 37;47  \e[0m\n----------------------------------------------------------------\nESC[5;Foreground;Background\n\e[5;30;40m 30;40  \e[5;30;41m 30;41  \e[5;30;42m 30;42  \e[5;30;43m 30;43  \e[5;30;44m 30;44  \e[5;30;45m 30;45  \e[5;30;46m 30;46  \e[5;30;47m 30;47  \e[0m\n\e[5;31;40m 31;40  \e[5;31;41m 31;41  \e[5;31;42m 31;42  \e[5;31;43m 31;43  \e[5;31;44m 31;44  \e[5;31;45m 31;45  \e[5;31;46m 31;46  \e[5;31;47m 31;47  \e[0m\n\e[5;32;40m 32;40  \e[5;32;41m 32;41  \e[5;32;42m 32;42  \e[5;32;43m 32;43  \e[5;32;44m 32;44  \e[5;32;45m 32;45  \e[5;32;46m 32;46  \e[5;32;47m 32;47  \e[0m\n\e[5;33;40m 33;40  \e[5;33;41m 33;41  \e[5;33;42m 33;42  \e[5;33;43m 33;43  \e[5;33;44m 33;44  \e[5;33;45m 33;45  \e[5;33;46m 33;46  \e[5;33;47m 33;47  \e[0m\n\e[5;34;40m 34;40  \e[5;34;41m 34;41  \e[5;34;42m 34;42  \e[5;34;43m 34;43  \e[5;34;44m 34;44  \e[5;34;45m 34;45  \e[5;34;46m 34;46  \e[5;34;47m 34;47  \e[0m\n\e[5;35;40m 35;40  \e[5;35;41m 35;41  \e[5;35;42m 35;42  \e[5;35;43m 35;43  \e[5;35;44m 35;44  \e[5;35;45m 35;45  \e[5;35;46m 35;46  \e[5;35;47m 35;47  \e[0m\n\e[5;36;40m 36;40  \e[5;36;41m 36;41  \e[5;36;42m 36;42  \e[5;36;43m 36;43  \e[5;36;44m 36;44  \e[5;36;45m 36;45  \e[5;36;46m 36;46  \e[5;36;47m 36;47  \e[0m\n\e[5;37;40m 37;40  \e[5;37;41m 37;41  \e[5;37;42m 37;42  \e[5;37;43m 37;43  \e[5;37;44m 37;44  \e[5;37;45m 37;45  \e[5;37;46m 37;46  \e[5;37;47m 37;47  \e[0m\n----------------------------------------------------------------\nESC[7;Foreground;Background\n\e[7;30;40m 30;40  \e[7;30;41m 30;41  \e[7;30;42m 30;42  \e[7;30;43m 30;43  \e[7;30;44m 30;44  \e[7;30;45m 30;45  \e[7;30;46m 30;46  \e[7;30;47m 30;47  \e[0m\n\e[7;31;40m 31;40  \e[7;31;41m 31;41  \e[7;31;42m 31;42  \e[7;31;43m 31;43  \e[7;31;44m 31;44  \e[7;31;45m 31;45  \e[7;31;46m 31;46  \e[7;31;47m 31;47  \e[0m\n\e[7;32;40m 32;40  \e[7;32;41m 32;41  \e[7;32;42m 32;42  \e[7;32;43m 32;43  \e[7;32;44m 32;44  \e[7;32;45m 32;45  \e[7;32;46m 32;46  \e[7;32;47m 32;47  \e[0m\n\e[7;33;40m 33;40  \e[7;33;41m 33;41  \e[7;33;42m 33;42  \e[7;33;43m 33;43  \e[7;33;44m 33;44  \e[7;33;45m 33;45  \e[7;33;46m 33;46  \e[7;33;47m 33;47  \e[0m\n\e[7;34;40m 34;40  \e[7;34;41m 34;41  \e[7;34;42m 34;42  \e[7;34;43m 34;43  \e[7;34;44m 34;44  \e[7;34;45m 34;45  \e[7;34;46m 34;46  \e[7;34;47m 34;47  \e[0m\n\e[7;35;40m 35;40  \e[7;35;41m 35;41  \e[7;35;42m 35;42  \e[7;35;43m 35;43  \e[7;35;44m 35;44  \e[7;35;45m 35;45  \e[7;35;46m 35;46  \e[7;35;47m 35;47  \e[0m\n\e[7;36;40m 36;40  \e[7;36;41m 36;41  \e[7;36;42m 36;42  \e[7;36;43m 36;43  \e[7;36;44m 36;44  \e[7;36;45m 36;45  \e[7;36;46m 36;46  \e[7;36;47m 36;47  \e[0m\n\e[7;37;40m 37;40  \e[7;37;41m 37;41  \e[7;37;42m 37;42  \e[7;37;43m 37;43  \e[7;37;44m 37;44  \e[7;37;45m 37;45  \e[7;37;46m 37;46  \e[7;37;47m 37;47  \e[0m\n"
    out = capture_stdout { messenger.color_chart }
    expect(out).to eq(s)
  end
end
