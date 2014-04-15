module CLIUtils
  class PrefixBehavior < PrefBehavior
    def evaluate(text)
      @parameters[:prefix] + text.to_s
    end
  end
end