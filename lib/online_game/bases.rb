require './attributes'
class Base < Attributes
  def source
    'base'
  end
end

class Burst < Base
  prop range: (2..3), power: 3, priority: 1
  at :start_of_beat, :retreat, select_from(retreat: [1])
end
class Shot < Base
  prop range: (1..4), priority: 2, power:3, stun_guard: 2
end
class Strike < Base
  prop range: (1..1), priority: 3, power: 4, stun_guard: 5
end
class Drive < Base
  prop range: (1..1), power: 3, priority: 4
  at :before_activation, :advance, select_from(advance: [1,2])
end
class Grasp < Base
  prop range: (1..1), power: 2, priority: 5
  at :on_hit, :move, select_from(pull: [1], push: [1])
end
class Dash < Base
  prop range: nil, power: nil, priority: 9
  at :after_activation, :move, ->(me,input) do
    initial_direction = me.direction
    select_from(advance:[1,2,3], retreat:[1,2,3]).call(me,input)
    unless initial_direction == me.direction
      me.dodge!
      puts "#{me.name} dodged attacks by switching sides!"
    end
  end
end


# Cadenza
class Press < Base
  prop range: (1..2), power: 1, priority: 0, stun_guard: 6
  # EXTRA POWER
end