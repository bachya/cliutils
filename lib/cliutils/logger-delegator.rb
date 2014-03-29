module CLIUtils
  #  ======================================================
  #  LoggerDelegator Class
  #
  #  Manages any configuration values and the flat YAML file
  #  into which they get stored.
  #  ======================================================
  class LoggerDelegator
    #  ====================================================
    #  Attributes
    #  ====================================================  
    attr_reader :devices

    #  ====================================================
    #  Methods
    #  ====================================================
    #  ----------------------------------------------------
    #  initialize method
    #
    #  Initializer
    #  @param *targets The endpoints to delegate to
    #  @return void
    #  ----------------------------------------------------
    def initialize(*targets)
      @targets = targets
      LoggerDelegator.delegate
    end

    #  ----------------------------------------------------
    #  attach method
    #
    #  Attaches a new target to delegate to.
    #  @return void
    #  ----------------------------------------------------  
    def attach(target)
      @targets << target
      LoggerDelegator.delegate
    end

    #  ----------------------------------------------------
    #  delegate_all method
    #
    #  Creates delegator methods for all of the methods
    #  on IO.
    #  @return void
    #  ----------------------------------------------------
    def self.delegate
      %w(log debug info warn error section success).each do |m|
        define_method(m) do |*args|
          @targets.map { |t| t.send(m, *args) }
        end
      end
    end

    #  ----------------------------------------------------
    #  detach method
    #
    #  Detaches a delegation target.
    #  @return void
    #  ----------------------------------------------------  
    def detach(target)
      @targets.delete(target)
      LoggerDelegator.delegate
    end
  end
end
