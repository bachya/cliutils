module CLIUtils
  # A Validator to verify whether a Pref answer
  # is not a number.
  class NumberValidator < PrefValidator
    # Runs the Validator against the answer.
    # @param [Object] text The "text" to evaluate
    # @return [String]
    def validate(text)
      @is_valid = text.to_s =~ /\A[-+]?\d*\.?\d+\z/
      @message = "Response is not a number: #{ text }"
    end
  end
end