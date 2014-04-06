module CLIUtils
  # PrefBehavior Module
  # Behaviors that should be applied to a Pref's
  # final value
  module PrefBehavior
    # Expands the passed text (assumes it
    # is a filepath).
    # @param [String] text The text to evaluate
    # @return [String]
    def self.local_filepath(text)
      File.expand_path(text)
    end
  end
end
