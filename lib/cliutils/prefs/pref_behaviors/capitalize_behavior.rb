module CLIUtils
  # A Behavior to capitalize a Pref answer
  class CapitalizeBehavior < PrefBehavior
    # Evaluates the behavior against the text.
    # @param [Object] text The "text" to evaluate
    # @return [String]
    def evaluate(text)
      text.to_s.capitalize
    end
  end
end