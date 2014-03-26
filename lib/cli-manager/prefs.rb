module CLIManager
  #  ======================================================
  #  PrefManager Class
  #
  #  Engine to derive preferences from a YAML file, deliver
  #  those to a user via a prompt, and collect the results.
  #  ======================================================
  class Prefs
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
    def initialize(yaml_path)
      if File.exists?(yaml_path)
        @config_path = yaml_path
        @prompts = YAML.load_file(yaml_path)
        @answers = []
        @deferred = []
      else
        fail "Invalid preferences file: #{ yaml_path }"
      end
    end

    #  ----------------------------------------------------
    #  deliver method
    #
    #  Runs through all of the prompt questions and collects
    #  answers from the user.
    #  @return Void
    #  ----------------------------------------------------
    def deliver
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

    #  ----------------------------------------------------
    #  deep_merge! method
    #
    #  Deep merges two hashes.
    #  deep_merge by Stefan Rusterholz;
    #  see http://www.ruby-forum.com/topic/142809
    #  @return Void
    #  ----------------------------------------------------
    def deep_merge!(target, data)
      merger = proc{|key, v1, v2|
        Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
      target.merge! data, &merger
    end
  end
end
