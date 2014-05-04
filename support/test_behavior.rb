module CLIUtils
  # A Behavior to prefix a Pref answer with a string
  class TestBehavior < PrefBehavior
    # Evaluates the behavior against the text.
    # @param [Object] text The "text" to evaluate
    # @return [String]
    def evaluate(text)
      "test behavior: #{ text }"
    end
  end
end
