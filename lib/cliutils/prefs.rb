require 'cliutils/prefs/pref'
require 'cliutils/pretty-io'

module CLIUtils
  # Engine to derive preferences from a YAML file, deliver
  # those to a user via a prompt, and collect the results.
  class Prefs
    include Messenging
    # Stores the filepath (if it exists) to the prefs file.
    # @return [String]
    attr_reader :config_path

    # Stores a Configurator instance.
    # @return [Configurator]
    attr_reader :configurator
    
    # Stores answers to prompt questions.
    # @return [Array]
    attr_reader :prefs

    # Reads prompt data from and stores it.
    # @param [<String, Hash, Array>] data Filepath to YAML, Hash, or Array
    # @param [Configurator] configurator The configurator to take default values from
    # @return [void]
    def initialize(data, configurator = nil)
      @answers = []
      @configurator = configurator
      @prefs = []

      case data
      when String
        if File.exists?(data)
          @config_path = data
          data = YAML::load_file(data).deep_symbolize_keys
          @prefs = _generate_prefs(data)
        else
          fail "Invalid configuration file: #{ data }" 
        end
      when Hash
        @config_path = nil
        data = {:prompts => data} unless data.keys[0] == :prompts
        data.deep_symbolize_keys!
        @prefs = _generate_prefs(data)
      when Array
        @config_path = nil
        data = {:prompts => data.deep_symbolize_keys}
        @prefs = _generate_prefs(data)
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
      puts ""
      @prefs.reject { |p| p.prereqs }.each do |p|
        _deliver_prompt(p)
      end
      
      @prefs.find_all { |p| p.prereqs }.each do |p|
        _deliver_prompt(p) if _prereqs_fulfilled?(p)
      end
      puts ""
    end

    private

    # Utility method for prompting the user to answer the
    # question (taking into account any options).
    # @param [Hash] p The prompt
    # @return [void]
    def _deliver_prompt(p)
      default = p.default
      
      unless @configurator.nil?
        unless @configurator.data[p.section.to_sym].nil?
          config_val = @configurator.data[p.config_section.to_sym][p.config_key.to_sym]
          default = config_val unless config_val.nil?
        end
      end

      valid_option_chosen = false
      until valid_option_chosen
        response = prompt(p.prompt, default)

        if p.validate(response)
          valid_option_chosen = true
          p.answer = p.evaluate_behaviors(response)
        else
          messenger.error(p.last_error_message)
        end
      end
    end

    # Generates an Array of Prefs based on passed
    # in data.
    # @param [Hash] pref_data Loaded pref data
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
        a = @prefs.detect do |answer|
          answer.config_key == req[:config_key] &&
          answer.answer == req[:config_value]
        end
        ret = false if a.nil?
      end
      ret
    end
  end
end
