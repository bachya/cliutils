require 'logger'

#  ======================================================
#  Logger Class
#  ======================================================
class Logger
  #  ----------------------------------------------------
  #  custom_level method
  #
  #  Creates a custom Logger level based on the passed
  #  tag.
  #  @param tag The Logger level to create
  #  @return Void
  #  ----------------------------------------------------
  def self.custom_level(tag)
    SEV_LABEL << tag 
    idx = SEV_LABEL.size - 1 

    define_method(tag.downcase.gsub(/\W+/, '_').to_sym) do |progname, &block|
      add(idx, nil, progname, &block)
    end 
  end 
  
  custom_level('PROMPT')
  custom_level('SECTION')
  custom_level('SUCCESS')
end