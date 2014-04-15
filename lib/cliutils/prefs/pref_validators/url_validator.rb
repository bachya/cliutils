require 'uri'

module CLIUtils
  class UrlValidator < PrefValidator
    def validate(text)
      @is_valid = text.to_s =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]
      @message = "Response is not a url: #{ text }"
    end
  end
end