module CLIUtils
  # PrefBehavior Module
  # Behaviors that should be applied to a Pref's
  # final value
  module PrefBehavior
    # Capitalizes the first word of the passed text.
    # @param [String] text The text to evaluate
    # @return [String]
    def self.capitalize(text)
      text.capitalize
    end

    # Expands the passed text (assumes it
    # is a filepath).
    # @param [String] text The text to evaluate
    # @return [String]
    def self.local_filepath(text)
      File.expand_path(text)
    end

    # Lowercases all characters in the passed text.
    # @param [String] text The text to evaluate
    # @return [String]
    def self.lowercase(text)
      text.downcase
    end

    # Adds a prefix to the passed text.
    # @param [String] text The text to evaluate
    # @param [String] text The prefix to add
    # @return [String]
    def self.prefix(text, prefix)
      prefix + text
    end

    # Adds a suffix to the passed text.
    # @param [String] text The text to evaluate
    # @param [String] text The suffix to add
    # @return [String]
    def self.suffix(text, suffix)
      text + suffix
    end

    # Capitalizes each word in the passed text.
    # @param [String] text The text to evaluate
    # @return [String]
    def self.titlecase(text)
      text.split.map(&:capitalize).join(' ')
    end

    # Uppercases all characters in the passed text.
    # @param [String] text The text to evaluate
    # @return [String]
    def self.uppercase(text)
      text.upcase
    end
  end
end
