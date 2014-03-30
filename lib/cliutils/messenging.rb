module CLIUtils
  #  CLIMessenger Module
  #  Outputs coordinated messages to a variety of targets.
  module Messenging
    include CLIUtils::PrettyIO

    # Hook that triggers when this module is included.
    # @param [Object] k The includer object
    # @return [void]
    def self.included(k)
      k.extend(self)
    end

    # Returns a default instance of LoggerDelegator that
    # delegates to STDOUT only.
    # @return [LoggerDelegator]
    def default_instance
      stdout_logger = Logger.new(STDOUT)
      stdout_logger.formatter = proc do |severity, datetime, progname, msg|
        send(severity.downcase, msg)
      end
      
      LoggerDelegator.new(stdout_logger)
    end

    # Singleton method to return (or initialize, if needed)
    # a LoggerDelegator.
    # @return [LoggerDelegator]
    def messenger
      @messenger ||= default_instance
    end
  end
end