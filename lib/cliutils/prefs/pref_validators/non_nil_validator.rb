module CLIUtils
  class NonNilValidator < PrefValidator
    def validate(text)
      @is_valid = !text.nil? && !text.empty?
      @message = 'Nil text not allowed'
    end
  end
end