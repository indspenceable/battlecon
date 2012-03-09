require File.join(File.dirname(__FILE__), 'attributes')

class Form < Attributes
  def source
    'form'
  end
end

class Clockwork < Form
  prop range: 0, priority: -3, power: 3, soak: 3
end
class Grapnel < Form
  prop range: (2..4), power:0, priority: 0
  at :on_hit, :pull, select_from(pull: [0,1,2,3])
end
class Mechanical < Form
  prop range: 0, power:2, priority: -2
  at :end_of_beat, :advance, select_from(advance: [0,1,2,3])
end
class Hydraulic < Form
  prop range: 0, priority: -1, power: 2, soak: 1
  at :before_activation, :advance, select_from(advance: [1])
end
class Battery < Form
  prop range:0, priority: -1, power: 1
  at :end_of_beat, :power, ->(me,input) {me.sources << Priority.new(4)}
end


class NoForm < Form
  prop range:0, priority: 0, power: 0
end
