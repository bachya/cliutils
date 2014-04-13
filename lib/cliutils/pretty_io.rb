begin
  unless (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM).nil?
    require 'Win32/Console/ANSI'
  end
rescue LoadError
  raise 'You must run `gem install win32console` to use CLIMessage on Windows'
end

require 'readline'

module CLIUtils
  # CLIMessenger Module
  # Outputs color-coordinated messages to a CLI
  module PrettyIO
    class << self
      # Determines whether wrapping should be enabled.
      # @return [Boolean]
      attr_accessor :wrap

      # Determines when strings should begin to wrap
      # @return [Integer]
      attr_accessor :wrap_char_limit
    end

    self.wrap = true
    self.wrap_char_limit = 80

    # Hook that triggers when this module is included.
    # @param [Object] k The includer object
    # @return [void]
    def self.included(k)
      k.extend(self)
    end

    # Displays a chart of all the possible ANSI foreground
    # and background color combinations.
    # @return [void]
    def color_chart
      [0, 1, 4, 5, 7].each do |attr|
        puts '----------------------------------------------------------------'
        puts "ESC[#{attr};Foreground;Background"
        30.upto(37) do |fg|
          40.upto(47) do |bg|
            print "\033[#{attr};#{fg};#{bg}m #{fg};#{bg}  "
          end
          puts "\033[0m"
        end
      end
    end

    # Empty method so that Messaging doesn't freak
    # out when passed a debug message.
    # @return [void]
    def debug(m); end

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
    # @param [<True, False>] multiline Whether the message should be multiline
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

    # Outputs a prompt, collects the user's response, and
    # returns it.
    # @param [String] prompt The prompt to output
    # @param [String] default The default option
    # @param [String] start_dir The directory to start from for autocompletion
    # @return [String]
    def prompt(prompt, default = nil, start_dir = '')
      Readline.completion_append_character = nil
      Readline.completion_proc = lambda do |prefix|
        files = Dir["#{start_dir}#{prefix}*"]
        files.map { |f| File.expand_path(f) }
             .map { |f| File.directory?(f) ? "#{ f }/" : f }
      end
      p = "# #{ prompt }#{ default.nil? ? ':' : " [default: #{ default }]:" } "
      choice = Readline.readline(p.cyan)
      if choice.empty?
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

    # Wraps a block in an opening and closing section message.
    # @param [String] m The opening message to output
    # @param [<True, False>] multiline Whether the message should be multiline
    # @yield
    # @return [void]
    def section_block(m, multiline = true)
      if block_given?
        if multiline
          section(m)
        else
          print _word_wrap(m, '---> ').purple
        end

        yield
      else
        fail 'Did not specify a valid block'
      end
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

    private

    # Outputs a wrapped string (where each line is limited
    # to a certain number of characters).
    # @param [String] text The text to wrap
    # @param [String] prefix_str The prefix for each line
    # @return [String]
    def _word_wrap(text, prefix_str)
      if PrettyIO.wrap
        return text if PrettyIO.wrap_char_limit <= 0

        limit = PrettyIO.wrap_char_limit - prefix_str.length
        text.gsub(/\n/, ' ')
            .gsub(/(.{1,#{ limit }})(\s+|$)/, "#{ prefix_str }\\1\n")
            .strip
      else
        text
      end
    end
  end
end
