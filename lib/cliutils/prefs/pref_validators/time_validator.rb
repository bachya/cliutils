module CLIUtils
  # A Validator to verify whether a Pref answer
  # is a valid time.
  class TimeValidator < PrefValidator
    # Runs the Validator against the answer.
    # @param [Object] text The "text" to evaluate
    # @return [String]
    def validate(text)
      @is_valid = text.to_s =~ /^([01]?[0-9]|2[0-3])\:[0-5][0-9](\s?[AaPp][Mm])?$/
      @message = "Response is not a time: #{ text }"
    end
  end
end