module CLIUtils
  # A Validator to verify whether a Pref answer
  # is a valid time.
  class TimeValidator < PrefValidator
    # Runs the Validator against the answer.
    # @param [Object] text The "text" to evaluate
    # @return [String]
    def validate(text)
      @is_valid = !(Time.parse(text) rescue nil).nil?
      @message = "Response is not a time: #{ text }"
    end
  end
end