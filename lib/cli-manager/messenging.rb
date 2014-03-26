module CLIManager
  #  ======================================================
  #  CLIMessenger Module
  #  Outputs color-coordinated messages to a CLI
  #  ======================================================
  module Messenging
    extend self

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
      k.class_eval { include PrettyIO }
      k.extend(self)
    end

    #  ----------------------------------------------------
    #  default_instance method
    #
    #  Returns a default instance of LoggerDelegator that
    #  delegates to STDOUT only.
    #  @return LoggerDelegator
    #  ----------------------------------------------------
    def default_instance
      stdout_logger = Logger.new(STDOUT)
      stdout_logger.formatter = proc do |severity, datetime, progname, msg|
        send(severity.downcase, msg)
      end
      
      LoggerDelegator.new(stdout_logger)
    end

    #  ----------------------------------------------------
    #  messenger method
    #
    #  Singleton method to return (or initialize, if needed)
    #  a LoggerDelegator.
    #  @return LoggerDelegator
    #  ----------------------------------------------------
    def messenger
      @messenger ||= default_instance
    end
  end
end