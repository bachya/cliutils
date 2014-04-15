module CLIUtils
  class TimeValidator < PrefValidator
    def validate(text)
      @is_valid = !(Time.parse(text) rescue nil).nil?
      @message = "Response is not a time: #{ text }"
    end
  end
end