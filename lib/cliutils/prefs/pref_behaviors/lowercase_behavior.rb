module CLIUtils
  # A Behavior to lowecase a Pref answer
  class LowercaseBehavior < PrefBehavior
    # Evaluates the behavior against the text.
    # @param [Object] text The "text" to evaluate
    # @return [String]
    def evaluate(text)
      text.to_s.downcase
    end
  end
end