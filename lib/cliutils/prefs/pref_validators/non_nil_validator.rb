module CLIUtils
  # A Validator to verify whether a Pref answer
  # is not empty or nil.
  class NonNilValidator < PrefValidator
    # Runs the Validator against the answer.
    # @param [Object] text The "text" to evaluate
    # @return [String]
    def validate(text)
      @is_valid = !text.nil? && !text.empty?
      @message = 'Nil text not allowed'
    end
  end
end