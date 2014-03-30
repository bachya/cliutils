require 'yaml'

module CLIUtils
  # Configuration Module
  # Manages any configuration values and the flat YAML file
  # into which they get stored.
  module Configuration
    # Hook that triggers when this module is included.
    # @param [Object] k The includer object
    # @return [void]
    def self.included(k)
      k.extend(self)
    end

    # Singleton method to return (or initialize, if needed)
    # a Configurator.
    # @return [Configurator]
    def configuration
      @@configuration ||= Configurator.new('~/.default-cliutils')
    end

    # Singleton method to return (or initialize, if needed)
    # a Configurator.
    # @param [String] path The filepath to use
    # @return [void]
    def load_configuration(path)
      @@configuration = Configurator.new(path)
    end
    alias configuration= load_configuration
  end
end
