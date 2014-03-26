#  ======================================================
#  SimpleDelegator Class
#
#  Manages any configuration values and the flat YAML file
#  into which they get stored.
#  ======================================================
class SimpleDelegator
  def initialize(*targets)
    @targets = targets
    SimpleDelegator.delegate_all
  end
  
  def self.delegate_all
    IO.methods.each do |m|
      define_method(m) do |*args|
        ret = nil
        @targets.each { |t| ret = t.send(m, *args) }
        ret
      end
    end
  end
end