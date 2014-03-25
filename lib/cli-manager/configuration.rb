module CLIManager
  #  ======================================================
  #  Configuration Class
  #
  #  Manages any configuration values and the flat YAML file
  #  into which they get stored.
  #  ======================================================
  class Configuration
    #  ====================================================
    #  Attributes
    #  ====================================================
    attr_reader :config_path, :data

    #  ====================================================
    #  Methods
    #  ====================================================
    #  ----------------------------------------------------
    #  initialize method
    #
    #  Initializes configuration from a flat file.
    #  @param path The filepath to the config YAML
    #  @return void
    #  ----------------------------------------------------
    def initialize(path)
      @config_path = path
      if File.exists?(path)
        @data = YAML.load_file(path)
      else
        fail "Invalid configuration filepath: #{ path }"
      end
    end

    #  ----------------------------------------------------
    #  add_section method
    #
    #  Adds a new section to the config file (if it doesn't
    #  already exist).
    #  @param section_name The section to add
    #  @return Void
    #  ----------------------------------------------------
    def add_section(section_name)
      if !@data.key?(section_name)
        @data[section_name] = {}
      else
        fail "Section already exists: #{ section_name }"
      end
    end

    #  ----------------------------------------------------
    #  delete_section method
    #
    #  Removes a section to the config file (if it exists).
    #  @param section_name The section to remove
    #  @return Void
    #  ----------------------------------------------------
    def delete_section(section_name)
      if @data.key?(section_name)
        @data.delete(section_name)
      else
        fail "Cannot delete nonexistent section: #{ section_name }"
      end
    end

    #  ----------------------------------------------------
    #  reset method
    #
    #  Clears the configuration data.
    #  @return Void
    #  ----------------------------------------------------
    def reset
      @data = {}
    end

    #  ----------------------------------------------------
    #  save method
    #
    #  Saves the configuration data to the previously
    #  stored flat file.
    #  @return Void
    #  ----------------------------------------------------
    def save
      File.open(@config_path, 'w') { |f| f.write(@data.to_yaml) }
    end    
  end
end
