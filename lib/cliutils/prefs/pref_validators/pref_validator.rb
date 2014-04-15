module CLIUtils
  class PrefValidator
    include Messaging

    attr_accessor :is_valid
    attr_accessor :message
    attr_accessor :parameters
    attr_accessor :pref
    
    def validate(text = nil)
      messenger.error("`validate` method not implemented on caller: #{ self.class }")
    end
  end
end