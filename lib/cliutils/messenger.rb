require 'cliutils/pretty_io'
require 'readline'

module CLIUtils
  # Allows for messages to be sent to STDOUT, as well
  # as any number of Logger instances.
  class Messenger
    include PrettyIO

    # The endpoints to which delegation occurs.
    # @return [Array]
    attr_reader :targets

    # Attaches a new target to delegate to.
    # @param [Hash] target A hash describing a reference key and a Logger
    # @return [void]
    def attach(target)
      fail "Cannot add invalid target: #{ target }" unless target.is_a?(Hash)
      @targets.merge!(target)
    end

    # Outputs a debug message; since this shouldn't appear in STDOUT,
    # only send it to the Logger targets.
    # @return [void]
    def debug(m)
      @targets.each { |_, t| t.debug { m } }
    end

    # Detaches a delegation target.
    # @param [<String, Symbol>] target_name The target to remove
    # @return [void]
    def detach(target_name)
      unless @targets.key?(target_name)
        fail "Cannot detach invalid target: #{ target_name }"
      end
      @targets.delete(target_name)
    end

    # Outputs a formatted-red error message.
    # @param [String] m The message to output
    # @return [void]
    def error(m)
      puts _word_wrap(m, '# ').red
      @targets.each { |_, t| t.error(m) }
    end

    # Outputs a formatted-blue informational message.
    # @param [String] m The message to output
    # @return [void]
    def info(m)
      puts _word_wrap(m, '# ').blue
      @targets.each { |_, t| t.info(m) }
    end

    # Deprecated method to show info messages around
    # a block of actions
    # @param [Array] params
    # @return [void]
    def info_block(*params)
      warn('As of 2.2.0, `info_block` is deprecated and nonfunctioning.')
    end

    # Initializes a new Messenger with an optional
    # Hash of targets.
    # @param [Hash] targets Logger targets
    def initialize(targets = {})
      @targets = targets
    end

    # Outputs a prompt, collects the user's response, and
    # returns it.
    # @param [String] prompt The prompt to output
    # @param [String] default The default option
    # @return [String]
    def prompt(prompt, default = nil)
      Readline.completion_append_character = nil
      Readline.completion_proc = Proc.new do |str|
        Dir[str + '*'].grep( /^#{ Regexp.escape(str) }/ )
      end

      p = "# #{ prompt }#{ default.nil? ? ':' : " [default: #{ default }]:" } "
      r = ''
      choice = Readline.readline(p.cyan)
      if choice.nil? || choice.empty?
        r = default
      else
        r = choice
      end

      @targets.each { |_, t| t.prompt("Answer to '#{ prompt }': #{ r }") }
      r
    end

    # Outputs a formatted-purple section message.
    # @param [String] m The message to output
    # @return [void]
    def section(m)
      puts _word_wrap(m, '---> ').purple
      @targets.each { |_, t| t.section(m) }
    end

    # Outputs a formatted-green success message.
    # @param [String] m The message to output
    # @return [void]
    def success(m)
      puts _word_wrap(m, '# ').green
      @targets.each { |_, t| t.success(m) }
    end

    # Outputs a formatted-yellow warning message.
    # @param [String] m The message to output
    # @return [void]
    def warn(m)
      puts _word_wrap(m, '# ').yellow
      @targets.each { |_, t| t.warn(m) }
    end
  end
end
