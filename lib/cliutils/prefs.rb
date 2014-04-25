require 'cliutils/prefs/pref'
require 'cliutils/pretty_io'

module CLIUtils
  # Engine to derive preferences from a YAML file, deliver
  # those to a user via a prompt, and collect the results.
  class Prefs
    include Messaging

    # Stores the filepath (if it exists) to the prefs file.
    # @return [String]
    attr_reader :config_path

    # Stores a Configurator instance.
    # @return [Configurator]
    attr_reader :configurator

    # Stores answers to prompt questions.
    # @return [Array]
    attr_reader :prompts

    class << self
      # Stores any actions registered for all
      # instances of Prefs.
      # @return [Hash]
      attr_accessor :registered_actions

      # Stores any behaviors registered for all
      # instances of Prefs.
      # @return [Hash]
      attr_accessor :registered_behaviors

      # Stores any validators registered for all
      # instances of Prefs.
      # @return [Hash]
      attr_accessor :registered_validators
    end

    self.registered_actions = {}
    self.registered_behaviors = {}
    self.registered_validators = {}

    # Reads prompt data from and stores it.
    # @param [<String, Hash, Array>] data Filepath to YAML, Hash, or Array
    # @param [Configurator] configurator Source of defailt values
    # @return [void]
    def initialize(data, configurator = nil)
      @prompts = []
      @configurator = configurator
      case data
      when String
        if File.file?(data)
          @config_path = data
          data = YAML.load_file(data).deep_symbolize_keys
          @prompts = _generate_prefs(data)
        else
          fail "Invalid configuration file: #{ data }"
        end
      when Hash
        @config_path = nil
        data = { prompts: data } unless data.keys[0] == :prompts
        data.deep_symbolize_keys!
        @prompts = _generate_prefs(data)
      when Array
        @config_path = nil
        data = { prompts: data }.deep_symbolize_keys
        @prompts = _generate_prefs(data)
      else
        fail 'Invalid configuration data'
      end
    end

    # Runs through all of the prompt questions and collects
    # answers from the user. Note that all questions w/o
    # prerequisites are examined first; once those are
    # complete, questions w/ prerequisites are examined.
    # @return [void]
    def ask
      # First, deliver all the prompts that don't have
      # any prerequisites.
      @prompts.reject { |p| p.prereqs }.each do |p|
        _deliver_prompt(p)
      end

      # After the "non-prerequisite" prompts are delivered,
      # deliver any that require prerequisites.
      @prompts.select { |p| p.prereqs }.each do |p|
        _deliver_prompt(p) if _prereqs_fulfilled?(p)
      end
    end

    # Deregister an action based on the symbol it was
    # stored under.
    # @param [Symbol] symbol The symbol to remove
    # @remove [void]
    def self.deregister_action(symbol)
      _deregister_asset(symbol, Pref::ASSET_TYPE_ACTION)
    end

    # Deregister a behavior based on the symbol it was
    # stored under.
    # @param [Symbol] symbol The symbol to remove
    # @remove [void]
    def self.deregister_behavior(symbol)
      _deregister_asset(symbol, Pref::ASSET_TYPE_BEHAVIOR)
    end

    # Deregister a validator based on the symbol it was
    # stored under.
    # @param [Symbol] symbol The symbol to remove
    # @remove [void]
    def self.deregister_validator(symbol)
      _deregister_asset(symbol, Pref::ASSET_TYPE_VALIDATOR)
    end

    # Register an action.
    # @param [String] path The filepath of the action
    # @remove [void]
    def self.register_action(path)
      self._register_asset(path, Pref::ASSET_TYPE_ACTION)
    end

    # Register a behavior.
    # @param [String] path The filepath of the behavior
    # @remove [void]
    def self.register_behavior(path)
      _register_asset(path, Pref::ASSET_TYPE_BEHAVIOR)
    end

    # Register a validator.
    # @param [String] path The filepath of the validator
    # @remove [void]
    def self.register_validator(path)
      _register_asset(path, Pref::ASSET_TYPE_VALIDATOR)
    end

    private

    # Utility method for prompting the user to answer the
    # question (taking into account any options).
    # @param [Hash] p The prompt
    # @return [void]
    def _deliver_prompt(p)
      default = p.default
      unless @configurator.nil?
        section_sym = p.config_section.to_sym

        # If a Configurator has been included, replace relevant
        # prompt defaults with those values from the Configurator.
        unless @configurator.data[section_sym].nil?
          config_val = @configurator.data[section_sym][p.config_key.to_sym]
          default = config_val unless config_val.nil?
        end
      end

      p.deliver(default)
    end

    # Generates an Array of Prefs based on passed
    # in data.
    # @param [Hash] pref_data_hash Loaded pref data
    # @return [Array]
    def _generate_prefs(pref_data_hash)
      pref_data_hash[:prompts].map { |p| CLIUtils::Pref.new(p) }
    end

    # Utility method for determining whether a prompt's
    # prerequisites have already been fulfilled.
    # @param [Hash] p The prompt
    # @return [void]
    def _prereqs_fulfilled?(p)
      ret = true
      p.prereqs.each do |req|
        a = @prompts.find do |answer|
          answer.config_key == req[:config_key] &&
          answer.answer == req[:config_value]
        end
        ret = false if a.nil?
      end
      ret
    end

    # Utility function to deregister an asset.
    # @param [Symbol] symbol The asset to remove
    # @param [Fixnum] type A Pref asset type
    # @return [void]
    def self._deregister_asset(symbol, type)
      case type
      when Pref::ASSET_TYPE_ACTION
        CLIUtils::Prefs.registered_actions.delete(symbol)
      when Pref::ASSET_TYPE_BEHAVIOR
        CLIUtils::Prefs.registered_behaviors.delete(symbol)
      when Pref::ASSET_TYPE_VALIDATOR
        CLIUtils::Prefs.registered_validators.delete(symbol)
      end
    end

    # Utility function to register an asset and associate
    # it with the Prefs eigenclass.
    # @param [String] path The filepath to the asset
    # @param [Fixnum] type A Pref asset type
    # @raise [StandardError] if the asset is unknown
    # @return [void]
    def self._register_asset(path, type)
      if File.file?(path)
        class_name = File.basename(path, '.*').camelize
        case type
        when Pref::ASSET_TYPE_ACTION
          k = class_name.sub('Action', '').to_sym
          unless CLIUtils::Prefs.registered_actions.key?(k)
            h = { k => { class: class_name, path: path } }
            CLIUtils::Prefs.registered_actions.merge!(h)
          end
        when Pref::ASSET_TYPE_BEHAVIOR
          k = class_name.sub('Behavior', '').to_sym
          unless CLIUtils::Prefs.registered_behaviors.key?(k)
            h = { k => { class: class_name, path: path } }
            CLIUtils::Prefs.registered_behaviors.merge!(h)
          end
        when Pref::ASSET_TYPE_VALIDATOR
          k = class_name.sub('Validator', '').to_sym
          unless CLIUtils::Prefs.registered_validators.key?(k)
            h = { k => { class: class_name, path: path } }
            CLIUtils::Prefs.registered_validators.merge!(h)
          end
        end
      else
        fail "Registration failed because of unknown filepath: #{ path }"
      end
    end
  end
end
