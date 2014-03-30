require 'yaml'

module CLIUtils
  #  Configuration Class
  #  Manages any configuration values and the flat YAML file
  #  into which they get stored.
  class Configurator
    # Stores the path to the configuration file.
    # @return [String]
    attr_reader :config_path
    
    # Stores the configuration data itself.
    # @return [Hash]
    attr_reader :data

    # Initializes configuration from a flat file.
    # @param [String] path The filepath to the config YAML
    # @return [void]
    def initialize(path)
      _path = File.expand_path(path)
      @config_path = _path
      @data = {}

      if File.exists?(_path)
        data = YAML::load_file(_path)
        @data.deep_merge!(data).deep_symbolize_keys!
      end
    end

    # Adds a new section to the config file (if it doesn't
    # already exist).
    # @param [String] section_name The section to add
    # @return [void]
    def add_section(section_name)
      if !@data.key?(section_name)
        @data[section_name] = {}
      else
        fail "Section already exists: #{ section_name }"
      end
    end

    # Removes a section to the config file (if it exists).
    # @param [String] section_name The section to remove
    # @return [void]
    def delete_section(section_name)
      if @data.key?(section_name)
        @data.delete(section_name)
      else
        fail "Cannot delete nonexistent section: #{ section_name }"
      end
    end

    # Ingests a Prefs class and adds its answers to the
    # configuration data.
    # @param [Prefs] prefs The Prefs class to examine
    # @return [void]
    def ingest_prefs(prefs)
      fail 'Invaid Prefs class' if !prefs.kind_of?(Prefs) || prefs.answers.nil?
      prefs.answers.each do |p|
        add_section(p[:section]) unless @data.key?(p[:section])
        @data[p[:section]].merge!(p[:key] => p[:answer])
      end
    end

    # Hook that fires when a non-existent method is called.
    # Allows this module to return data from the config
    # Hash when given a method name that matches a key.
    # @return [Hash]
    def method_missing(name, *args, &block)
      @data[name.to_sym] || @data.merge!(name.to_sym => {})
    end

    # Clears the configuration data.
    # @return [void]
    def reset
      @data = {}
    end

    # Saves the configuration data to the previously
    # stored flat file.
    # @return [void]
    def save
      File.open(@config_path, 'w') { |f| f.write(@data.deep_stringify_keys.to_yaml) }
    end
  end
end
