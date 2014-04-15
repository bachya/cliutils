module CLIUtils
  class TitlecaseBehavior < PrefBehavior
    def evaluate(text)
      text.to_s.split.map(&:capitalize).join(' ')
    end
  end
end