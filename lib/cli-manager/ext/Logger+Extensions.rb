require 'logger'

class Logger
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