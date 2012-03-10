require File.join(File.dirname(__FILE__), 'attributes')

class Form < Attributes
  def source
    'form'
  end
end
class NoForm < Form
  prop range:0, priority: 0, power: 0
end
