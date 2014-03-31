module CLIUtils
  # LoggerDelegator Class
  # Delegates certain Logger methods to a number of different
  # targets.
  class LoggerDelegator
    # The endpoints to which delegation occurs.
    # @return [Array]
    attr_reader :targets

    # Initializes and creates methods for the passed targets.
    # @param [Logger] targets The endpoints to delegate to
    # @return [void]
    def initialize(targets)
      @targets = targets
      LoggerDelegator.delegate
    end

    # Attaches a new target to delegate to.
    # @param [Logger] target The targets to delegate to
    # @return [void]
    def attach(target)
      fail "Cannot add invalid target: #{ target }" unless target.is_a?(Hash)
      @targets.merge!(target)
      LoggerDelegator.delegate
    end

    # Creates delegator methods for a specific list of Logger
    # functions.
    # @return [void]
    def self.delegate
      %w(log debug info warn error section success).each do |m|
        define_method(m) do |*args|
          @targets.each_value { |v| v.send(m, *args) }
        end
      end
    end

    # Detaches a delegation target.
    # @param [<String, Symbol>] target_name The target to remove
    # @return [void]
    def detach(target_name)
      fail "Cannot delete invalid target: #{ target_name }" unless @targets.key?(target_name)
      @targets.delete(target_name)
      LoggerDelegator.delegate
    end
  end
end
