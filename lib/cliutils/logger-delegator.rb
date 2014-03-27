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
    LoggerDelegator.delegate_all
  end

  #  ----------------------------------------------------
  #  attach method
  #
  #  Attaches a new target to delegate to.
  #  @return void
  #  ----------------------------------------------------  
  def attach(target)
    @targets << target
    LoggerDelegator.delegate_all
  end

  #  ----------------------------------------------------
  #  delegate_all method
  #
  #  Creates delegator methods for all of the methods
  #  on IO.
  #  @return void
  #  ----------------------------------------------------
  def self.delegate_all
    IO.methods.each do |m|
      define_method(m) do |*args|
        ret = nil
        @targets.each { |t| ret = t.send(m, *args) }
        ret
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
    LoggerDelegator.delegate_all
  end
end