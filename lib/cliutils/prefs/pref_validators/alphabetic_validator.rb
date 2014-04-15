module CLIUtils
  class AlphabeticValidator < PrefValidator
    def validate(text)
      @is_valid = text.to_s =~ /\A[A-Za-z\s]+\z/
      @message = "Response is not alphabetic: #{ text }"
    end
  end
end