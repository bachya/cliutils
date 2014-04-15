module CLIUtils
  class ExpandFilepathBehavior < PrefBehavior
    def evaluate(text)
      File.expand_path(text.to_s)
    end
  end
end