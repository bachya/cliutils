module CLIUtils
  # A Validator to verify whether a Pref answer
  # is alphanumeric (made up of letters, numbers
  # and spaces).
  class AlphanumericValidator < PrefValidator
    # Runs the Validator against the answer.
    # @param [Object] text The "text" to evaluate
    # @return [String]
    def validate(text)
      @is_valid = text.to_s =~ /\A[A-Za-z0-9\s]+\z/
      @message = "Response is not alphanumeric: #{ text }"
    end
  end
end