require 'logger'

module CLIManager
  #  ======================================================
  #  CLILogging Module
  #  Persistent logger to a file
  #  ======================================================
  module CLILogging
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

    def change_logger(new_logger)
      @@logger = new_logger
    end

    def logger
      @@logger ||= Logger.new(STDOUT)
    end
  end
end