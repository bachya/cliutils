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
        puts "Failed to open #{ url }: #{ exception }"
      end
    end
  end
end