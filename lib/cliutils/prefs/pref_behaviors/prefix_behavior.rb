module CLIUtils
  # A Behavior to prefix a Pref answer with a string
  class PrefixBehavior < PrefBehavior
    # Evaluates the behavior against the text.
    # @param [Object] text The "text" to evaluate
    # @return [String]
    def evaluate(text)
      @parameters[:prefix] + text.to_s
    end
  end
end