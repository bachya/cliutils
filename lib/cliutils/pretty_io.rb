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
