module CLIUtils
  class LowercaseBehavior < PrefBehavior
    def evaluate(text)
      text.to_s.downcase
    end
  end
end