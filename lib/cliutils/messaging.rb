require 'cliutils/messenger'

module CLIUtils
  # Allows access to a single, unified instances of
  # CLUtils::Messenger.
  module Messaging
    # Singleton method to return (or initialize, if needed)
    # a CLIUtils::Messenger.
    # @return [Messenger]
    def messenger
      @@messenger ||= CLIUtils::Messenger.new
    end
  end
end
