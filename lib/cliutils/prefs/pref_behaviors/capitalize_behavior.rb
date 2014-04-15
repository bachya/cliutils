module CLIUtils
  class CapitalizeBehavior < PrefBehavior
    def evaluate(text)
      text.to_s.capitalize
    end
  end
end