module CLIUtils
  # A Behavior to titlecase a Pref answer
  class TitlecaseBehavior < PrefBehavior
    # Evaluates the behavior against the text.
    # @param [Object] text The "text" to evaluate
    # @return [String]
    def evaluate(text)
      text.to_s.split.map(&:capitalize).join(' ')
    end
  end
end