module CLIUtils
  # The generic base class for a Pref
  # Action.
  class PrefAction
    include Messaging

    # Holds the parameters that apply to
    # this Action.
    # @return [Hash]
    attr_accessor :parameters

    # Runs the Action. Note that the
    # method implemented here will throw
    # an exception by default, meaning that
    # the user's subclass *needs* to
    # implement it.
    # @param [Hash] parameters
    # @raise [StandardError] if the subclass
    #   doesn't implement this method.
    # @return [void]
    def run
      fail "`run` method not implemented on caller: #{ self.class }"
    end
  end
end
