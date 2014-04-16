module CLIUtils
  # A Validator to verify whether a Pref answer
  # is a date.
  class DateValidator < PrefValidator
    # Runs the Validator against the answer.
    # @param [Object] text The "text" to evaluate
    # @return [String]
    def validate(text)
      @is_valid = !(Date.parse(text) rescue nil).nil?
      @message = "Response is not a date: #{ text }"
    end
  end
end