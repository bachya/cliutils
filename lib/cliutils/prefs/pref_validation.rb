require 'uri'

module CLIUtils
  # PrefValidation Module
  # Validation rules that can be applied to a Pref.
  module PrefValidation
    # Struct to contain a validation result
    # and a result message.
    Validator = Struct.new(:code, :message)

    # Validates that a value is only letters
    # and spaces.
    # @param [String] text The text to inspect
    # @return [Boolean]
    def self.alphabetic(text)
      m = "Response is not alphabetic: #{ text }"
      c = text.to_s =~ /\A[A-Za-z\s]+\z/
      Validator.new(c, m)
    end

    # Validates that a value is only letters, numbers
    # and spaces.
    # @param [String] text The text to inspect
    # @return [Boolean]
    def self.alphanumeric(text)
      m = "Response is not alphanumeric: #{ text }"
      c = text.to_s =~ /\A[A-Za-z0-9\s]+\z/
      Validator.new(c, m)
    end

    # Validates that a value is a date.
    # @param [String] text The text to inspect
    # @return [Boolean]
    def self.date(text)
      m = "Response is not a date: #{ text }"
      c = !(Date.parse(text) rescue nil).nil?
      Validator.new(c, m)
    end

    # Validates that a value is a datetime.
    # @param [String] text The text to inspect
    # @return [Boolean]
    def self.datetime(text)
      m = "Response is not a datetime: #{ text }"
      c = !(DateTime.parse(text) rescue nil).nil?
      Validator.new(c, m)
    end

    # Validates that a value is passed and is not
    # empty.
    # @param [String] text The text to inspect
    # @return [Boolean]
    def self.non_nil(text)
      m = 'Nil text not allowed'
      c = !text.nil? && !text.empty?
      Validator.new(c, m)
    end

    # Validates that a value is some sort of number.
    # @param [String] text The text to inspect
    # @return [Boolean]
    def self.number(text)
      m = "Response is not a number: #{ text }"
      c = text.to_s =~ /\A[-+]?\d*\.?\d+\z/
      Validator.new(c, m)
    end

    # Validates that a filepath exists on the
    # local filesystem.
    # @param [String] text The text to inspect
    # @return [Boolean]
    def self.filepath_exists(text)
      m = "Path does not exist locally: #{ text }"
      c = Pathname.new(text).exist?
      Validator.new(c, m)
    end

    # Validates that a value is a time.
    # @param [String] text The text to inspect
    # @return [Boolean]
    def self.time(text)
      m = "Response is not a time: #{ text }"
      c = !(Time.parse(text) rescue nil).nil?
      Validator.new(c, m)
    end

    # Validates that passed value is a URL.
    # @param [String] text The text to inspect
    # @return [Boolean]
    def self.url(text)
      m = "Response is not a url: #{ text }"
      c = text.to_s =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]
      Validator.new(c, m)
    end
  end
end
