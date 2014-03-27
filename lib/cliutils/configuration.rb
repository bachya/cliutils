module CLIManager
  #  ======================================================
  #  Configuration Class
  #
  #  Manages any configuration values and the flat YAML file
  #  into which they get stored.
  #  ======================================================
  module Configuration
    #  ====================================================
    #  Methods
    #  ====================================================
    #  ----------------------------------------------------
    #  included method
    #
    #  Hook called when this module gets mixed in; extends
    #  the includer with the methods defined here.
    #  @param k The includer
    #  @return Void
    #  ----------------------------------------------------
    def self.included(k)
      k.extend(self)
    end

    #  ----------------------------------------------------
    #  configuration method
    #
    #  Singleton method to return (or initialize, if needed)
    #  a Configurator.
    #  @return Configurator
    #  ----------------------------------------------------
    def configuration
      @configuration ||= Configurator.new('~/.default-cliutils')
    end

    #  ----------------------------------------------------
    #  load_configuration method
    #
    #  Initializes a Configurator with the passed filepath.
    #  @param path The path to the config file
    #  @return Void
    #  ----------------------------------------------------
    def load_configuration(path)
      @configuration = Configurator.new(path)
    end
  end
end
