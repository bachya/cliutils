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
    def initialize(*targets)
      @targets = targets
      LoggerDelegator.delegate
    end

    # Attaches a new target to delegate to.
    # @param [Logger] target The targets to delegate to
    # @return [void]
    def attach(target)
      @targets << target
      LoggerDelegator.delegate
    end

    # Creates delegator methods for a specific list of Logger
    # functions.
    # @return [void]
    def self.delegate
      %w(log debug info warn error section success).each do |m|
        define_method(m) do |*args|
          @targets.map { |t| t.send(m, *args) }
        end
      end
    end

    # Detaches a delegation target.
    # @return [void]
    def detach(target)
      @targets.delete(target)
      LoggerDelegator.delegate
    end
  end
end
