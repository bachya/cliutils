begin
   require 'Win32/Console/ANSI' if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
rescue LoadError
   raise 'You must run `gem install win32console` to use CLIMessage on Windows'
end

require 'readline'

module CLIManager
  #  ======================================================
  #  CLIMessenger Module
  #  Outputs color-coordinated messages to a CLI
  #  ======================================================
  module PrettyIO
    #  ====================================================
    #  Methods
    #  ====================================================
    #  ----------------------------------------------------
    #  included method
    #
    #  Hook called when this module gets mixed in; extends
    #  the includer with the methods defined here.
    #  @param k The includer
    #  @return Void
    #  ----------------------------------------------------
    def self.included(k)
      k.extend(self)
    end

    #  ----------------------------------------------------
    #  error method
    #
    #  Outputs a formatted-red error message.
    #  @param m The message to output
    #  @return Void
    #  ----------------------------------------------------
    def error(m)
      puts word_wrap(m, '# ').red
    end

    #  ----------------------------------------------------
    #  info method
    #
    #  Outputs a formatted-blue informational message.
    #  @param m The message to output
    #  @return Void
    #  ----------------------------------------------------
    def info(m)
      puts word_wrap(m, '# ').blue
    end

    #  ----------------------------------------------------
    #  info_block method
    #
    #  Wraps a block in an opening and closing info message.
    #  @param m1 The opening message to output
    #  @param m2 The closing message to output
    #  @param multiline Whether the message should be multiline
    #  @return Void
    #  ----------------------------------------------------
    def info_block(m1, m2 = 'Done.', multiline = false)
      if block_given?
        if multiline
          info(m1)
        else
          print word_wrap(m1, '# ').blue
        end

        yield

        if multiline
          info(m2)
        else
          puts word_wrap(m2, '# ').blue
        end
      else
        fail 'Did not specify a valid block'
      end
    end

    #  ----------------------------------------------------
    #  prompt method
    #
    #  Outputs a prompt, collects the user's response, and
    #  returns it.
    #  @param prompt The prompt to output
    #  @param default The default option
    #  @return String
    #  ----------------------------------------------------
    def prompt(prompt, default = nil, start_dir = '')
      Readline.completion_append_character = nil
      Readline.completion_proc = lambda do |prefix|
        files = Dir["#{start_dir}#{prefix}*"]
        files.
          map { |f| File.expand_path(f) }.
          map { |f| File.directory?(f) ? f + "/" : f }
      end
      choice = Readline.readline("# #{ prompt }#{ default.nil? ? ':' : " [default: #{ default }]:" } ".cyan)
      if choice.empty?
        default
      else
        choice
      end
    end

    #  ----------------------------------------------------
    #  section method
    #
    #  Outputs a formatted-purple section message.
    #  @param m The message to output
    #  @return Void
    #  ----------------------------------------------------
    def section(m)
      puts word_wrap(m, '---> ').purple
    end

    #  ----------------------------------------------------
    #  section_block method
    #
    #  Wraps a block in an opening and closing section
    #  message.
    #  @param m1 The opening message to output
    #  @param m2 The closing message to output
    #  @param multiline A multiline message or not
    #  @return Void
    #  ----------------------------------------------------
    def section_block(m, multiline = true)
      if block_given?
        if multiline
          section(m)
        else
          print word_wrap(m, '---> ').purple
        end

        yield
      else
        fail 'Did not specify a valid block'
      end
    end

    #  ----------------------------------------------------
    #  success method
    #
    #  Outputs a formatted-green success message.
    #  @param m The message to output
    #  @return Void
    #  ----------------------------------------------------
    def success(m)
      puts word_wrap(m, '# ').green
    end

    #  ----------------------------------------------------
    #  warning method
    #
    #  Outputs a formatted-yellow warning message.
    #  @param m The message to output
    #  @return Void
    #  ----------------------------------------------------
    def warn(m)
      puts word_wrap(m, '# ').yellow
    end
    
    private

    #  ----------------------------------------------------
    #  word_wrap method
    #
    #  Outputs a wrapped string (where each line is limited
    #  to a certain number of characters).
    #  @param text The text to wrap
    #  @param prefix_str The prefix for each line
    #  @param line_width The number of characters per line
    #  @return String
    #  ----------------------------------------------------
    def word_wrap(text, prefix_str, line_width = 40) 
      return text if line_width <= 0
      text.gsub(/\n/, ' ').gsub(/(.{1,#{line_width - prefix_str.length}})(\s+|$)/, "#{ prefix_str }\\1\n").strip
    end
  end
end