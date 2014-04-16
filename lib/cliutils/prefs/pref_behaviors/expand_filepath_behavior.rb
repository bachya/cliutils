module CLIUtils
  # A Behavior to run File.expand_path on a
  # Pref answer
  class ExpandFilepathBehavior < PrefBehavior
    # Evaluates the behavior against the text.
    # @param [Object] text The "text" to evaluate
    # @return [String]
    def evaluate(text)
      File.expand_path(text.to_s)
    end
  end
end