module CLIUtils
  #  ======================================================
  #  PrefManager Class
  #
  #  Engine to derive preferences from a YAML file, deliver
  #  those to a user via a prompt, and collect the results.
  #  ======================================================
  class Prefs
    include PrettyIO
    #  ====================================================
    #  Attributes
    #  ====================================================
    attr_reader :answers, :config_path, :prompts

    #  ====================================================
    #  Methods
    #  ====================================================
    #  ----------------------------------------------------
    #  initialize method
    #
    #  Reads prompt data from YAML file.
    #  @return Void
    #  ----------------------------------------------------
    def initialize(data)
      @answers = []
      @deferred = []
      
      case data
      when String
        if File.exists?(data)
          @config_path = data
          @prompts = YAML.load_file(data)
        else
          fail "Invalid configuration file: #{ yaml_path }"
        end
      when Array
        @config_path = nil
        @prompts = {:prompts => data}
      else
        fail 'Invalid configuration data'
      end
    end

    #  ----------------------------------------------------
    #  deliver method
    #
    #  Runs through all of the prompt questions and collects
    #  answers from the user.
    #  @return Void
    #  ----------------------------------------------------
    def ask
      @prompts[:prompts].each do |p|
        if p[:requirements]
          @deferred << p
          next
        end
      
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
    end
  end
end
