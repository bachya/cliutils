module CLIUtils
  class NumberValidator < PrefValidator
    def validate(text)
      @is_valid = text.to_s =~ /\A[-+]?\d*\.?\d+\z/
      @message = "Response is not a number: #{ text }"
    end
  end
end