module CLIUtils
  # The generic base class for a Pref
  # action.
  class PrefAction
    include Messaging

    # Runs the plugin. Note that the
    # method implemented here shows
    # an error (indicating that it
    # needs to be implemented in a
    # subclass).
    # @parameter [Hash] parameters
    # @return [void]
    def run(parameters = {})
      messenger.error("`run` method not implemented on caller: #{ self.class }")
    end
  end
end