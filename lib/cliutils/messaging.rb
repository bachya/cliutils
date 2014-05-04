require 'cliutils/messenger'

module CLIUtils
  #  CLIMessenger Module
  #  Outputs coordinated messages to a variety of targets.
  module Messaging
    # Singleton method to return (or initialize, if needed)
    # a LoggerDelegator.
    # @return [LoggerDelegator]
    def messenger
      @@messenger ||= CLIUtils::Messenger.new
    end
  end
end
