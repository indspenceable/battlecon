class Base
  # TODO - this should be an "Alteration" class, which is the base class of Base, Form, Token, Paradigm, etc.
  def self.at time, name, callback
    @triggers ||= {}
    @triggers[time] ||= []
    trigger = :"_#{time}_#{name}"
    @triggers[time] << trigger

    define_method trigger do |*args|
      callback.call *args
      self.instance_variable_set(:"@#{trigger}", true)
    end
  end
  [:start_of_beat, :before_activation, :on_hit, :on_damage, :after_activation, :end_of_beat].each do |t|
    define_method t do
      triggers = self.class.instance_variable_get(:@triggers) rescue nil
      if triggers && triggers[t]
        triggers[t].reject{|t| self.instance_variable_get(:"@#{t}")}
      else
        []
      end
    end
  end
  def self.prop hash
    hash.each do |name,val|
      define_method name do
        val
      end
    end
  end


  # abstract out the idea of a number of potential options. Given each method you can do => list of the
  # potential values you can give it, filter out all the ones that return `method?(val) == false`. If 0,
  # error, if 1, do it, if more, give option to player.
  def self.select_from methods_to_options
    return ->(me,input) do
      valid_options = {}
      methods_to_options.each do |method, options|
        confirm = :"#{method}?"
        valid_options[method] = options.select{|e| me.send(confirm, e)}
      end
      valid_options.delete_if{|k,v| v.empty?}
      count_of_valid_options = valid_options.values.map(&:size).inject(&:+)

      case count_of_valid_options
      when 0
        puts "Not possible to do #{method} with any of #{methods_to_option.inspect}."
      when 1
        method,arg = *valid_options.first
        arg = arg[0]
        puts "Doing: #{method} -> #{arg}"
        me.send(:"#{valid_options.first.first}!", valid_options.first.last.first)
      else
        method,arg = *input.request!(valid_options.map{|k,v| v.map{|i| "#{k}:#{i}"}}.flatten).split(':')
        puts "Doing: #{method} -> #{arg}"
        me.send(:"#{method}!", arg.to_i)
      end
    end
  end


  # default properties - power, range, and priority are always printed on every card
  # so they don't have defaults. but stun guard and soak are presumed to be 0.
  prop stun_guard: 0
  prop soak: 0
end

class Burst < Base
  prop range: (2..3), damage: 3, priority: 1
  at :start_of_beat, :retreat, select_from(retreat: [1])
end
class Shot < Base
  prop range: (1..4), priority: 2, damage:3, stun_guard: 2
end
class Strike < Base
  prop range: (1..1), priority: 3, damage: 4, stun_guard: 5
end
class Drive < Base
  prop range: (1..1), damage: 3, priority: 4
  at :before_activation, :advance, select_from(advance: [1,2])
end
class Grasp < Base
  prop range: (1..1), damage: 2, priority: 5
  at :on_hit, :move, select_from(pull: [1], push: [1])
end
class Dash < Base
  prop range: nil, damage: nil, priority: 9
  at :after_activation, :move, ->(me,input) do
    initial_direction = me.direction
    select_from(advance:[1,2,3], retreat:[1,2,3]).call(me,input)
    unless initial_direction == me.direction
      me.dodge!
      puts "#{me.name} dodged attacks by switching sides!"
    end
  end
end
