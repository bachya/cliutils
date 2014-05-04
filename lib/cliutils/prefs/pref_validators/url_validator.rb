require 'uri'

module CLIUtils
  # A Validator to verify whether a Pref answer
  # is a valid URL.
  class UrlValidator < PrefValidator
    # Runs the Validator against the answer.
    # @param [Object] text The "text" to evaluate
    # @return [String]
    def validate(text)
      @is_valid = text.to_s =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]
      @message = "Response is not a URL: #{ text }"
    end
  end
end