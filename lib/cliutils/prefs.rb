require 'cliutils/pretty-io'

module CLIUtils
  # Engine to derive preferences from a YAML file, deliver
  # those to a user via a prompt, and collect the results.
  class Prefs
    include PrettyIO
    attr_reader :answers, :config_path, :prompts

    # Reads prompt data from and stores it.
    # @param [<String, Hash, Array>] data Filepath to YAML, Hash, or Array
    # @return [void]
    def initialize(data)
      @answers = []
      @prompts = {}

      case data
      when String
        if File.exists?(data)
          @config_path = data

          prompts = YAML::load_file(data)
          @prompts.deep_merge!(prompts).deep_symbolize_keys!
        else
          fail "Invalid configuration file: #{ yaml_path }"
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
      if p[:options].nil?
        pref = prompt(p[:prompt], p[:default])
      else
        valid_option_chosen = false
        until valid_option_chosen
          pref = prompt(p[:prompt], p[:default])
          if p[:options].include?(pref)
            valid_option_chosen = true
          else
            error("Invalid option chosen: #{ pref }")
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
