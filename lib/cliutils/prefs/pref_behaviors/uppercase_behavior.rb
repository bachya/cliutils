module CLIUtils
  # A Behavior to uppercase a Pref answer
  class UppercaseBehavior < PrefBehavior
    # Evaluates the behavior against the text.
    # @param [Object] text The "text" to evaluate
    # @return [String]
    def evaluate(text)
      text.to_s.upcase
    end
  end
end