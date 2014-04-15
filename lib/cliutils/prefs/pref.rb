require 'cliutils/messaging'
require 'cliutils/prefs/pref_behavior'
require 'cliutils/prefs/pref_validation'

module CLIUtils
  # Pref Class
  # An individual preference
  class Pref
    include Messaging

    # Stores the answer to this Pref.
    # @return [String, Symbol]
    attr_accessor :answer

    # Stores instantiated behavior objects.
    # @return [Hash]
    attr_accessor :behavior_objects

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

    # Stores the message and behavior that should be
    # executed after the prompt is delivered.
    # @return [Hash]
    attr_accessor :post

    # Stores the message and behavior that should be
    # executed before the prompt is delivered.
    # @return [Hash]
    attr_accessor :pre

    # Stores the prereqs information.
    # @return [Array]
    attr_accessor :prereqs

    # Stores the prompt text.
    # @return [String]
    attr_accessor :prompt_text

    # Stores instantiated Validators
    # @return [Hash]
    attr_accessor :validator_objects

    # Stores key/value combinations required to show this Pref.
    # @return [Hash]
    attr_accessor :validators

    # Initializes a new Pref via passed-in parameters.
    # @param [Hash] params Parameters to initialize
    # @return [void]
    def initialize(params = {})
      params.each { |key, value| send("#{ key }=", value) }
      
      _load_validators if @validators
      _load_behaviors if @behaviors
    end

    # Custom equality operator for this class.
    # @param [Pref] other
    # @return [Boolean]
    def ==(other)
      @config_key == other.config_key &&
      @config_section == other.config_section &&
      @prompt_text == other.prompt_text
    end

    # Delivers the prompt the user. Handles retries
    # after incorrect answers, validation, behavior
    # evaluation, and pre-/post-behaviors.
    # @param [String] default The default option
    # @return [void]
    def deliver(default = nil)
      # Design decision: the pre-prompt behavior
      # gets evaluated *once*, not every time the
      # user gets prompted. This prevents multiple
      # evaluations when bad options are provided.
      _eval_pre if @pre

      valid_option_chosen = false
      until valid_option_chosen
        response = prompt(@prompt_text, default)
        if validate(response)
          valid_option_chosen = true
          @answer = evaluate_behaviors(response)
          _eval_post if @post
        else
          messenger.error(@last_error_message)
        end
      end
    end

    # Runs the passed text through this Pref's behaviors.
    # @param [String] text The text to evaluate
    # @return [String]
    def evaluate_behaviors(text)
      if @behaviors
        modified_text = text
        @behaviors.each do |method|
          if method.is_a?(Hash)
            parameter = method.values[0]
            method = method.keys[0]
          end

          args = [modified_text, parameter]
          if PrefBehavior.respond_to?(method)
            modified_text = PrefBehavior.send(method, *args)
          else
            messenger.warn("Skipping undefined Pref Behavior: #{ b }")
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
          @last_error_message = "Invalid option chosen (\"#{ text }\"); " \
          "valid options are: #{ options }"
          ret = false
        end
      end
      ret
    end

    # Validates a text against the validators for this Pref
    # @param [String] text The text to validate
    # @return [Boolean]
    def _confirm_validators(text)
      # ret = true
      # if @validators
      #   @validators.each do |v|
      #     if PrefValidation.respond_to?(v)
      #       validator = PrefValidation.send(v, text)
      #       unless validator.code
      #         @last_error_message = validator.message
      #         ret = false
      #       end
      #     else
      #       messenger.warn("Skipping undefined Pref Validator: #{ v }")
      #     end
      #   end
      # end
      # ret
    end

    # Evaluates the pre-prompt Hash and does the right thing. :)
    # @return [void]
    def _eval_pre
      info(@pre[:message])
      prompt('Press enter to continue')
      
      if (@pre[:action])
        action_obj = _load_action(@pre[:action])
        action_obj.pref = self
        action_obj.run(@pre[:action_parameters][0])
      end
    end

    # Evaluates the post-prompt Hash and does the right thing. :)
    # @return [void]
    def _eval_post
      info(@post[:message])

      if (@post[:action])
        action_obj = _load_action(@post[:action])
        action_obj.pref = self
        action_obj.run(@post[:action_parameters][0])
      end
    end

    # Loads a Pref Action, instantiates it (if it exists),
    # and returns that instance. Note that the passed
    # String can be a name (thus translating to an included
    # Action) or a filepath to a user-defined Action.
    # @param [String] path_or_name The name of or path to an Action
    # @return [Object]
    def _load_action(path_or_name)
      if File.exist?(path_or_name)
        # If the file exists, we're assuming that the user
        # passed a filepath.
        action_path = File.expand_path(path_or_name) if path_or_name.start_with?('~') 
        action_path = "#{ path_or_name }_action"
        action_name = File.basename(path_or_name, '.*').camelize
      else
        # If it doesn't, we're assuming that the user
        # passed a class name.
        _default =  File.join(File.dirname(__FILE__), 'pref_actions')
        action_path = File.join(_default, "#{ path_or_name }_action")
        action_name = path_or_name.camelize
      end

      # Try to load and instantiate the Action. If that fails, warn
      # the user with a message and skip over it.
      begin
        require action_path
        Object.const_get("CLIUtils::#{ action_name }Action").new
      rescue
        messenger.warn("Skipping undefined Pref Action: #{ path_or_name }")
      end
    end

    def _load_behaviors
      
    end

    def _load_validators
      @validators.each do |v|
        puts v
      end
    end
  end
end
