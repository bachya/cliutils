require 'uri'

module CLIUtils
  # A Validator to verify whether a Pref answer
  # is a valid URL.
  class TestValidator < PrefValidator
    # Runs the Validator against the answer.
    # @param [Object] text The "text" to evaluate
    # @return [String]
    def validate(text)
      @is_valid = text.to_s == "bachya"
      @message = "String did not equal 'bachya': #{ text }"
    end
  end
end