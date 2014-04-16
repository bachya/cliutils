module CLIUtils
  # A Behavior to suffix a Pref answer with a string
  class SuffixBehavior < PrefBehavior
    # Evaluates the behavior against the text.
    # @param [Object] text The "text" to evaluate
    # @return [String]
    def evaluate(text)
      text.to_s + @parameters[:suffix]
    end
  end
end