require 'launchy'

module CLIUtils
  # Pref Action to open a URL in the default
  # browser.
  class OpenUrlAction < PrefAction
    # Runs the action.
    # @return [void]
    def run
      url = @parameters[:url]
      Launchy.open(url) do |exception|
        fail "Failed to open URL: #{ exception }" if exception
      end
    end
  end
end