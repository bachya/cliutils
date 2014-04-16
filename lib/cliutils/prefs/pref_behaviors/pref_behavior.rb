module CLIUtils
  # The generic base class for a Pref
  # Behavior.
  class PrefBehavior
    include Messaging

    # Holds the parameters associated with
    # this behavior.
    # @return [Hash]
    attr_accessor :parameters

    # Holds a reference to the Pref that
    # is applying this Behavior.
    # @return [Pref]
    attr_accessor :pref

    # Eva
    # @parameter [Hash] parameters
    # @raise [StandardError] if the subclass
    #   doesn't implement this method.
    # @return [void]
    def evaluate(text = '')
      fail "`evaluate` method not implemented on caller: #{ self.class }"
    end
  end
end