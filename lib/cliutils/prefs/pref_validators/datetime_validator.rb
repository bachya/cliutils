module CLIUtils
  class DatetimeValidator < PrefValidator
    def validate(text)
      @is_valid = !(DateTime.parse(text) rescue nil).nil?
      @message = "Response is not a datetime: #{ text }"
    end 
  end
end