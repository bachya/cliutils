module CLIUtils
  class UppercaseBehavior < PrefBehavior
    def evaluate(text)
      text.to_s.upcase
    end
  end
end