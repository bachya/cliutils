require 'cliutils/messenging'
require 'cliutils/prefs/pref-behavior'
require 'cliutils/prefs/pref-validation'

module CLIUtils
  # Pref Class
  # An individual preference
  class Pref
    include Messenging

    # Stores the answer to this Pref.
    # @return [String, Symbol]
    attr_accessor :answer

    # Stores the behaviors that this Pref conforms to.
    # @return [Array]
    attr_accessor :behaviors

    # Stores a key to reference this pref in a Configurator.
    # @return [String, Symbol]
    attr_accessor :config_key

    # Stores a Configurator section to stick this Pref under.
    # @return [String, Symbol]
    attr_accessor :config_section

    # Stores the default text.
    # @return [String]
    attr_accessor :default

    # Stores the last error message.
    # @return [String]
    attr_accessor :last_error_message

    # Stores the valid options the user can pick from.
    # @return [Array]
    attr_accessor :options

    # Stores the prereqs information.
    # @return [Array]
    attr_accessor :prereqs

    # Stores the prompt text.
    # @return [String]
    attr_accessor :prompt
    
    # Stores key/value combinations required to show this Pref.
    # @return [Hash]
    attr_accessor :validators

    # Initializes a new Pref via passed-in parameters.
    # @param [Hash] params Parameters to initialize
    # @return [void]
    def initialize(params = {})
      params.each { |key, value| send("#{ key }=", value) }
    end

    # Runs the passed text through this Pref's behaviors.
    # @param [String] text The text to evaluate
    # @return [String]
    def evaluate_behaviors(text)
      if @behaviors
        modified_text = text
        @behaviors.each do |b|
          if PrefBehavior.respond_to?(b)
            modified_text = PrefBehavior.send(b, modified_text)
          else
            messenger.warn("Skipping undefined Pref behavior: #{ b }")
          end
        end
        
        modified_text
      else
        text
      end
    end

    # Validates a text against this pref's options and
    # validators.
    # @param [String] text The text to validate
    # @return [Boolean]
    def validate(text)
      _confirm_options(text) &&
      _confirm_validators(text)
    end
    
    private

    # Validates a text against the options for this Pref
    # @param [String] text The text to validate
    # @return [Boolean]
    def _confirm_options(text)
      ret = true
      if @options
        unless @options.include?(text)
          @last_error_message = "Invalid option chosen (\"#{ text }\"); valid options are: #{ options }"
          ret = false
        end
      end

      ret
    end

    # Validates a text against the validators for this Pref
    # @param [String] text The text to validate
    # @return [Boolean]
    def _confirm_validators(text)
      ret = true
      if @validators
        @validators.each do |v|
          if PrefValidation.respond_to?(v)
            validator = PrefValidation.send(v, text)
            unless validator.code
              @last_error_message = validator.message
              ret = false
            end
          else
            messenger.warn("Skipping undefined Pref validator: #{ v }")
          end
        end
      end
      
      ret
    end
  end
end