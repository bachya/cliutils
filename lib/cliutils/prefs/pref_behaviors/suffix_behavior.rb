module CLIUtils
  class SuffixBehavior < PrefBehavior
    def evaluate(text)
      text.to_s + @parameters[:suffix]
    end
  end
end