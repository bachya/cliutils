begin
   require 'Win32/Console/ANSI' if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
rescue LoadError
   raise 'You must run `gem install win32console` to use CLI colors on Windows'
end

require 'readline'

module CLIManager
  #  ======================================================
  #  CliManager Module
  #  Singleton to manage common CLI interfacing
  #  ======================================================
  module CLIMessage
    #  ====================================================
    #  Methods
    #  ====================================================
    #  ----------------------------------------------------
    #  error method
    #
    #  Outputs a formatted-red error message.
    #  @param m The message to output
    #  @return Void
    #  ----------------------------------------------------
    def error(m)
      puts "# #{ m }".red
    end

    #  ----------------------------------------------------
    #  info method
    #
    #  Outputs a formatted-blue informational message.
    #  @param m The message to output
    #  @return Void
    #  ----------------------------------------------------
    def info(m)
      puts "# #{ m }".blue
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
          print "# #{ m1 }".blue
        end

        yield

        if multiline
          info(m2)
        else
          puts m2.blue
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
      choice = Readline.readline("# #{ prompt }#{ default.nil? ? ':' : " [default: #{ default }]:" } ".green)
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
      puts "---> #{ m }".purple
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
          print "---> #{ m }".purple
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
      puts "# #{ m }".green
    end

    #  ----------------------------------------------------
    #  warning method
    #
    #  Outputs a formatted-yellow warning message.
    #  @param m The message to output
    #  @return Void
    #  ----------------------------------------------------
    def warning(m)
      puts "# #{ m }".yellow
    end
  end
end