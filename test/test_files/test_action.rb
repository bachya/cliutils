module CLIUtils
  # Pref Action to open a URL in the default
  # browser.
  class TestAction < PrefAction
    # Runs the action.
    # @return [void]
    def run
      puts 'here'
    end
  end
end