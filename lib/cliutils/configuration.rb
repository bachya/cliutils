require 'logger'

module CLIUtils
  # Configuration Module
  # Manages any configuration values and the flat YAML file
  # into which they get stored.
  module Configuration
    extend self

    # Allows easy access to Logger levels.
    LOG_LEVELS = {
      'DEBUG' => Logger::DEBUG,
      'INFO'  => Logger::INFO,
      'WARN'  => Logger::WARN,
      'ERROR' => Logger::ERROR,
      'FATAL' => Logger::FATAL
    }

    @@configuration = nil

    # Singleton method to return (or initialize, if needed)
    # a Configurator.
    # @return [Configurator]
    def configuration
      if @@configuration
        @@configuration
      else
        fail 'Attempted to access `configuration` before ' \
        'executing `load_configuration`'
      end
    end

    # Singleton method to return (or initialize, if needed)
    # a Configurator.
    # @param [String] path The filepath to use
    # @return [void]
    def load_configuration(path)
      @@configuration = Configurator.new(path)
    end
    alias_method :filepath=, :load_configuration
  end
end
