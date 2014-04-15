module CLIUtils
  class DateValidator < PrefValidator
    def validate(text)
      @is_valid = !(Date.parse(text) rescue nil).nil?
      @message = "Response is not a date: #{ text }"
    end
  end
end