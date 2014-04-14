module CLIUtils
  class OpenUrlAction < PrefAction
    def run(parameters)
      `open #{ parameters[:url] }`
    end
  end
end