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
    end

    #  ----------------------------------------------------
    #  attach method
    #
    #  Attaches a new target to delegate to.
    #  @return void
    #  ----------------------------------------------------  
    def attach(target)
      @targets << target
    end

    #  ----------------------------------------------------
    #  detach method
    #
    #  Detaches a delegation target.
    #  @return void
    #  ----------------------------------------------------  
    def detach(target)
      @targets.delete(target)
    end
    
    %w(log debug info warn error section success).each do |m|
        define_method(m) do |*args|
            @targets.map { |t| t.send(m, *args) }
        end
    end
  end
end
