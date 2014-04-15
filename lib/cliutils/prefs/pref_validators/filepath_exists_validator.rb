module CLIUtils
  class FilepathExistsValidator < PrefValidator
    def validate(text)
      @is_valid = Pathname.new(text.to_s).exist?
      @message = "Path does not exist locally: #{ text }"
    end
  end
end