module CLIUtils
  # Pref Class
  # An individual preference
  class Pref
    include Messaging

    # Constant defining a Behavior
    ASSET_TYPE_BEHAVIOR = 1

    # Constant defining a Validator
    ASSET_TYPE_VALIDATOR = 2

    @@asset_labels = [
      { class_suffix: 'Behavior',  file_suffix: 'behavior'  },
      { class_suffix: 'Validator', file_suffix: 'validator' }
    ]

    # Stores the answer to this Pref.
    # @return [String, Symbol]
    attr_accessor :answer

    # Stores instantiated Behavior objects.
    # @return [Array]
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
    # @return [Array]
    attr_accessor :validator_objects

    # Stores key/value combinations required to show this Pref.
    # @return [Hash]
    attr_accessor :validators

    # Initializes a new Pref via passed-in parameters.
    # @param [Hash] params Parameters to initialize
    # @return [void]
    def initialize(params = {})
      @behavior_objects = []
      @validator_objects = []

      params.each { |key, value| send("#{ key }=", value) }
      @validators.each { |v| _load_validator(v) } if @validators
      @behaviors.each { |b| _load_behavior(b) } if @behaviors
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
      # if @behaviors
      #   modified_text = text
      #   @behaviors.each do |method|
      #     if method.is_a?(Hash)
      #       parameter = method.values[0]
      #       method = method.keys[0]
      #     end
      # 
      #     args = [modified_text, parameter]
      #     if PrefBehavior.respond_to?(method)
      #       modified_text = PrefBehavior.send(method, *args)
      #     else
      #       messenger.warn("Skipping undefined Pref Behavior: #{ b }")
      #     end
      #   end
      #   modified_text
      # else
      #   text
      # end
    end

    # Validates a text against this pref's options and
    # validators.
    # @param [String] text The text to validate
    # @return [Boolean]
    def validate(text)
      _validate_options(text) &&
      _validate_validators(text)
    end

    private

    # Validates a text against the options for this Pref
    # @param [String] text The text to validate
    # @return [Boolean]
    def _validate_options(text)
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
    def _validate_validators(text)
      ret = true
      if @validator_objects
        @validator_objects.each do |v|
          v.validate(text)
          unless v.is_valid
            @last_error_message = v.message
            ret = false
          end
        end
      end
      ret
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

    def _load_behavior(behavior_hash)
      obj = _load_asset(ASSET_TYPE_BEHAVIOR, behavior_hash[:name])

      unless obj.nil?
        obj.pref = self
        obj.parameters = behavior_hash[:parameters]
        @behavior_objects << obj
      end
    end

    def _load_asset(type, path_or_name)
      if File.exist?(path_or_name)
        # If the file exists, we're assuming that the user
        # passed a filepath.
        asset_path = File.expand_path(path_or_name) if path_or_name.start_with?('~') 
        asset_path = "#{ path_or_name }_#{ @@asset_labels[type - 1][:file_suffix] }"
        asset_name = File.basename(path_or_name, '.*').camelize
      else
        # If it doesn't, we're assuming that the user
        # passed a class name.
        _default =  File.join(File.dirname(__FILE__), "pref_#{ @@asset_labels[type - 1][:file_suffix] }s")
        asset_path = File.join(_default, "#{ path_or_name }_#{ @@asset_labels[type - 1][:file_suffix] }")
        asset_name = path_or_name.camelize
      end

      # Try to load and instantiate the Action. If that fails, warn
      # the user with a message and skip over it.
      begin
        require asset_path
        Object.const_get("CLIUtils::#{ asset_name }#{ @@asset_labels[type - 1][:class_suffix] }").new
      rescue LoadError
        messenger.warn("Skipping undefined Pref #{ @@asset_labels[type - 1][:class_suffix] }: #{ path_or_name }")
        nil
      end
    end

    def _load_validator(path_or_name)
      obj = _load_asset(ASSET_TYPE_VALIDATOR, path_or_name)

      unless obj.nil?
        obj.pref = self
        @validator_objects << obj
      end
    end
  end
end
