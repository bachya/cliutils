module CLIUtils
  # PrefBehavior Module
  # Behaviors that should be applied to a Pref's
  # final value
  module PrefBehavior
    # Capitalizes the first word of the passed text.
    # @param [String] args[0] The text to evaluate
    # @return [String]
    def self.capitalize(*args)
      args[0].capitalize
    end

    # Expands the passed text (assumes it
    # is a filepath).
    # @param [String] args[0] The text to evaluate
    # @return [String]
    def self.expand_filepath(*args)
      File.expand_path(args[0])
    end

    # Lowercases all characters in the passed text.
    # @param [String] args[0] The text to evaluate
    # @return [String]
    def self.lowercase(*args)
      args[0].downcase
    end

    # Adds a prefix to the passed text.
    # @param [String] args[0] The text to evaluate
    # @param [String] args[1] The prefix to add
    # @return [String]
    def self.prefix(*args)
      args[1] + args[0]
    end

    # Adds a suffix to the passed text.
    # @param [String] args[0] The text to evaluate
    # @param [String] args[1] The suffix to add
    # @return [String]
    def self.suffix(*args)
      args[0] + args[1]
    end

    # Capitalizes each word in the passed text.
    # @param [String] args[0] The text to evaluate
    # @return [String]
    def self.titlecase(*args)
      args[0].split.map(&:capitalize).join(' ')
    end

    # Uppercases all characters in the passed text.
    # @param [String] args[0] The text to evaluate
    # @return [String]
    def self.uppercase(*args)
      args[0].upcase
    end
  end
end
