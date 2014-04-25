module CLIUtils
  # The generic base class for a Pref
  # Behavior.
  class PrefBehavior
    include Messaging

    # Holds the parameters associated with
    # this behavior.
    # @return [Hash]
    attr_accessor :parameters

    # Evaluate the Behavior!
    # @param [String] text
    # @raise [StandardError] if the subclass
    #   doesn't implement this method.
    # @return [void]
    def evaluate(text = '')
      fail "`evaluate` method not implemented on caller: #{ self.class }"
    end
  end
end
