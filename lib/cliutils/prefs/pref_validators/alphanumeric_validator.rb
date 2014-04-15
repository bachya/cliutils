module CLIUtils
  class AlphanumericValidator < PrefValidator
    def validate(text)
      @is_valid = text.to_s =~ /\A[A-Za-z0-9\s]+\z/
      @message = "Response is not alphanumeric: #{ text }"
    end
  end
end