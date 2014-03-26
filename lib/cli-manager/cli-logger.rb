class CLILogger
  def initialize(*targets)
    @targets = targets
  end

  %w(log debug info warn error).each do |m|
    define_method(m) do |*args|
      @targets.map { |t| t.send(m, *args) }
    end
  end
end