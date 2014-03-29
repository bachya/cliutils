require 'yaml'

module CLIUtils
  #  ======================================================
  #  Configuration Class
  #
  #  Manages any configuration values and the flat YAML file
  #  into which they get stored.
  #  ======================================================
  class Configurator
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
      _path = File.expand_path(path)
      @config_path = _path
      @data = {}

      if File.exists?(_path)
        data = YAML::load_file(_path)
        @data.deep_merge!(data).deep_symbolize_keys!
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
    #  ingest_prefs method
    #
    #  Ingests a Prefs class and adds its answers to the
    #  configuration data.
    #  @param prefs The Prefs class to examine
    #  @return Void
    #  ----------------------------------------------------
    def ingest_prefs(prefs)
      fail 'Invaid Prefs class' if !prefs.kind_of?(Prefs) || prefs.answers.nil?
      prefs.answers.each do |p|
        add_section(p[:section]) unless @data.key?(p[:section])
        @data[p[:section]].merge!(p[:key] => p[:answer])
      end
    end

    #  ----------------------------------------------------
    #  method_missing method
    #
    #  Allows this module to return data from the config
    #  Hash when given a method name that matches a key.
    #  @param name
    #  @param *args
    #  @param &block
    #  @return Hash
    #  ----------------------------------------------------
    def method_missing(name, *args, &block)
      @data[name.to_sym] || @data.merge!(name.to_sym => {})
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
      File.open(@config_path, 'w') { |f| f.write(@data.deep_stringify_keys.to_yaml) }
    end
  end
end
