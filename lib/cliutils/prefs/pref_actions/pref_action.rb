module CLIUtils
  # The generic base class for a Pref
  # action.
  class PrefAction
    include Messaging

    attr_accessor :parameters

    # Holds a reference to the pref that
    # is implementing this action.
    # @return [Pref]
    attr_accessor :pref

    # Runs the plugin. Note that the
    # method implemented here shows
    # an error (indicating that it
    # needs to be implemented in a
    # subclass).
    # @parameter [Hash] parameters
    # @return [void]
    def run
      fail "`run` method not implemented on caller: #{ self.class }"
    end
  end
end