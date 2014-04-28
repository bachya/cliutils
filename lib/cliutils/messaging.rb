require 'cliutils/pretty_io'
require 'readline'

module CLIUtils
  #  CLIMessenger Module
  #  Outputs coordinated messages to a variety of targets.
  module Messaging
    include PrettyIO

    # Hook that triggers when this module is included.
    # @param [Object] k The includer object
    # @return [void]
    def self.included(k)
      k.extend(self)
    end

    # Empty method so that Messaging doesn't freak out when passed a debug
    # message.
    # @return [void]
    def debug(m); end

    # Returns a default instance of LoggerDelegator that delegates to STDOUT
    # only.
    # @return [LoggerDelegator]
    def default_instance
      stdout_logger = Logger.new(STDOUT)
      stdout_logger.formatter = proc do |severity, datetime, progname, msg|
        send(severity.downcase, msg)
      end

      LoggerDelegator.new(STDOUT: stdout_logger)
    end

    # Outputs a formatted-red error message.
    # @param [String] m The message to output
    # @return [void]
    def error(m)
      puts _word_wrap(m, '# ').red
    end

    # Outputs a formatted-blue informational message.
    # @param [String] m The message to output
    # @return [void]
    def info(m)
      puts _word_wrap(m, '# ').blue
    end

    # Wraps a block in an opening and closing info message.
    # @param [String] m1 The opening message to output
    # @param [String] m2 The closing message to output
    # @param [Boolean] multiline Whether the message should be multiline
    # @yield
    # @return [void]
    def info_block(m1, m2 = 'Done.', multiline = false)
      if block_given?
        if multiline
          info(m1)
        else
          print _word_wrap(m1, '# ').blue
        end

        yield

        if multiline
          info(m2)
        else
          puts _word_wrap(m2, '# ').blue
        end
      else
        fail 'Did not specify a valid block'
      end
    end

    # Empty method so that Messaging doesn't freak
    # out when passed a log message.
    # @return [void]
    def log(m); end

    # Singleton method to return (or initialize, if needed)
    # a LoggerDelegator.
    # @return [LoggerDelegator]
    def messenger
      @@messenger ||= default_instance
    end

    # Outputs a prompt, collects the user's response, and
    # returns it.
    # @param [String] prompt The prompt to output
    # @param [String] default The default option
    # @param [String] start_dir The directory to start from for autocompletion
    # @return [String]
    def prompt(prompt, default = nil, start_dir = '')
      Readline.completion_append_character = nil
      Readline.completion_proc = Proc.new do |str|
        Dir[str + '*'].grep( /^#{ Regexp.escape(str) }/ )
      end

      p = "# #{ prompt }#{ default.nil? ? ':' : " [default: #{ default }]:" } "
      choice = Readline.readline(p.cyan)
      if choice.nil? || choice.empty?
        default
      else
        choice
      end
    end

    # Outputs a formatted-purple section message.
    # @param [String] m The message to output
    # @return [void]
    def section(m)
      puts _word_wrap(m, '---> ').purple
    end

    # Outputs a formatted-green success message.
    # @param [String] m The message to output
    # @return [void]
    def success(m)
      puts _word_wrap(m, '# ').green
    end

    # Outputs a formatted-yellow warning message.
    # @param [String] m The message to output
    # @return [void]
    def warn(m)
      puts _word_wrap(m, '# ').yellow
    end
  end
end
