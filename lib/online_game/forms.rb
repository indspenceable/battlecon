require File.join(File.dirname(__FILE__), 'attributes')
module Online
  class Form < Attributes
    def source
      'form'
    end
  end
end