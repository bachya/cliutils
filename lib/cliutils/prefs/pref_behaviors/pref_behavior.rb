module CLIUtils
  class PrefBehavior
    include Messaging

    attr_accessor :parameters
    attr_accessor :pref
    
    def evaluate(text = '')
      fail "`evaluate` method not implemented on caller: #{ self.class }"
    end
  end
end