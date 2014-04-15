module CLIUtils
  # Pref Action to open a URL in the default
  # browser.
  class OpenUrlAction < PrefAction
    # Runs the action.
    # @return [void]
    def run
      `open #{ @parameters[:url] }`
    end
  end
end