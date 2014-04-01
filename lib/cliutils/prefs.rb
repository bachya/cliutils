require 'cliutils/pretty-io'
require 'cliutils/configuration'

module CLIUtils
  # Engine to derive preferences from a YAML file, deliver
  # those to a user via a prompt, and collect the results.
  class Prefs
    include PrettyIO
    # Stores answers to prompt questions.
    # @return [Array]
    attr_reader :answers
    
    # Stores the filepath (if it exists) to the prefs file.
    # @return [String]
    attr_reader :config_path

    # Stores a Configurator instance.
    # @return [Configurator]
    attr_reader :configurator
    
    # Stores answers to prompt questions.
    # @return [Hash]
    attr_reader :prompts

    # Reads prompt data from and stores it.
    # @param [<String, Hash, Array>] data Filepath to YAML, Hash, or Array
    # @param [Configurator] configurator The configurator to take default values from
    # @return [void]
    def initialize(data, configurator = nil)
      @answers = []
      @configurator = configurator
      @prompts = {}

      case data
      when String
        if File.exists?(data)
          @config_path = data

          prompts = YAML::load_file(data)
          @prompts.deep_merge!(prompts).deep_symbolize_keys!
        else
          fail "Invalid configuration file: #{ data }"
        end
      when Hash
        @config_path = nil
        
        data = {:prompts => data} unless data.keys[0] == :prompts
        @prompts.deep_merge!(data).deep_symbolize_keys!
      when Array
        @config_path = nil

        prompts = {:prompts => data}
        @prompts.deep_merge!(prompts).deep_symbolize_keys!
      else
        fail 'Invalid configuration data'
      end
    end

    # Runs through all of the prompt questions and collects
    # answers from the user. Note that all questions w/o
    # requirements are examined first; once those are
    # complete, questions w/ requirements are examined.
    # @return [void]
    def ask
      @prompts[:prompts].reject { |p| p[:requirements] }.each do |p|
        _deliver_prompt(p)
      end

      @prompts[:prompts].find_all { |p| p[:requirements] }.each do |p|
        _deliver_prompt(p) if _requirements_fulfilled?(p)
      end
    end

    private

    # Utility method for prompting the user to answer the
    # question (taking into account any options).
    # @param [Hash] p The prompt
    # @return [void]
    def _deliver_prompt(p)
      default = p[:default]
      
      unless @configurator.nil?
        unless @configurator.data[p[:section].to_sym].nil?
          config_val = @configurator.data[p[:section].to_sym][p[:key].to_sym]
          default = config_val unless config_val.nil?
        end
      end
      
      if p[:options].nil?
        pref = prompt(p[:prompt], default)
      else
        valid_option_chosen = false
        until valid_option_chosen
          pref = prompt(p[:prompt], default)
          if p[:options].include?(pref)
            valid_option_chosen = true
          else
            error("Invalid option chosen (\"#{ pref }\"); valid options are: #{ p[:options] }")
          end
        end
      end
      p[:answer] = pref
      @answers << p
    end

    # Utility method for determining whether a prompt's
    # requirements have already been fulfilled.
    # @param [Hash] p The prompt
    # @return [void]
    def _requirements_fulfilled?(p)
      ret = true
      p[:requirements].each do |req|
        a = @answers.detect do |answer|
          answer[:key] == req[:key] &&
          answer[:answer] == req[:value]
        end
        ret = false if a.nil?
      end
      ret
    end
  end
end
