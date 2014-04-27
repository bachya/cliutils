require 'pathname'

module CLIUtils
  # A Validator to verify whether a Pref answer
  # is a local filepath that exists.
  class FilepathExistsValidator < PrefValidator
    # Runs the Validator against the answer.
    # @param [Object] text The "text" to evaluate
    # @return [String]
    def validate(text)
      @is_valid = Pathname.new(text.to_s).exist?
      @message = "Path does not exist locally: #{ text }"
    end
  end
end