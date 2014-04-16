module CLIUtils
  # A Validator to verify whether a Pref answer
  # is a datetime.
  class DatetimeValidator < PrefValidator
    # Runs the Validator against the answer.
    # @param [Object] text The "text" to evaluate
    # @return [String]
    def validate(text)
      @is_valid = !(DateTime.parse(text) rescue nil).nil?
      @message = "Response is not a datetime: #{ text }"
    end 
  end
end