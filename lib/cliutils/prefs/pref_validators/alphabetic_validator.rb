module CLIUtils
  # A Validator to verify whether a Pref answer
  # is alphabetic (made up of letters and spaces).
  class AlphabeticValidator < PrefValidator
    # Runs the Validator against the answer.
    # @param [Object] text The "text" to evaluate
    # @return [String]
    def validate(text)
      @is_valid = text.to_s =~ /\A[A-Za-z\s]+\z/
      @message = "Response is not alphabetic: #{ text }"
    end
  end
end