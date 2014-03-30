#  String Class extensions
class String

  # Outputs a string in a formatted color.
  # @param [<Integer, String>] color_code The code to use
  # @return [void]
  def colorize(color_code)
    "\033[#{ color_code }m#{ self }\033[0m"
  end
  
  # Makes the associated string blue.
  # @return [void]
  def blue; colorize(34) end

  # Makes the associated string cyan.
  # @return [void]
  def cyan; colorize(36) end

  # Makes the associated string green.
  # @return [void]
  def green; colorize(32) end

  # Makes the associated string purple.
  # @return [void]
  def purple; colorize(35) end

  # Makes the associated string red.
  # @return [void]
  def red; colorize(31) end

  # Makes the associated string white.
  # @return [void]
  def white; colorize(37) end

  # Makes the associated string yellow.
  # @return [void]
  def yellow; colorize(33) end
end
