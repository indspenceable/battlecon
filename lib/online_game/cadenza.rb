require File.join(File.dirname(__FILE__), 'tokens')
require File.join(File.dirname(__FILE__), 'bases')
require File.join(File.dirname(__FILE__), 'forms')
require File.join(File.dirname(__FILE__), 'player')

# Iron body token
class IronBody < Token
  prop stun_immunity: true
end

#FORMS
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
  at :end_of_beat, :power, ->(me,input) {me.active_tokens << Priority.new(4)}
end

# Unique Base
class Press < Base
  prop range: (1..2), power: 1, priority: 0, stun_guard: 6
  at :no_trigger, :gather_power, ->(me,input) do
    me.gather_power!
  end
end


class Cadenza < Player
  def initialize *args
    super
    @forms = [
      Clockwork.new,
      Grapnel.new,
      Mechanical.new,
      Hydraulic.new,
      Battery.new
    ]
    @bases << Press.new
    @iron_body_token_count = 3
    @active_tokens = []
    @gathering_power_for_press = false
  end
  
  # If cadenza has a token left, he may spend it to get STUN
  # IMMUNITY for the round, but only during ante
  def ante
    @iron_body = false
    @gathering_power_for_press = false
    return false if @active_tokens.any?{|t| t.is_a? IronBody }
    if @iron_body_token_count > 0
      if @input.request!(['iron_body','pass']) == 'iron_body'
        @active_tokens << IronBody.new
        @iron_body_token_count -= 1
        true
      end
    end
  end
  def gather_power!
    puts "GATHERING POWER FOR PRESS"
    @gathering_power_for_press = 0
  end

  def take_damage! damage
    d = super
    @gathering_power_for_press += d  and puts "MORE POWER" if @gathering_power_for_press
    d
  end
  def power
    (@gathering_power_for_press || 0) + super
  end

  # Cadenza's main ability is that whenever he would get stunned,
  # he can spend a token to negate that stun.
  def stuns? damage
    if super && !@iron_body
      if @iron_body_token_count > 0
        if @input.request!(['iron_body','pass']) == 'iron_body'
          @iron_body = true
          @iron_body_token_count -= 1
          return false
        end
      end
      true
    end
  end
  
  #TODO - this might just make sense to have in the player.
  #Essentially everyone is going to use this (except, of course, ZAAM)
  def aux_sources
    @active_tokens
  end
  def active_tokens
    @active_tokens
  end
  def end_of_beat!
    @active_tokens = []
    super
  end
end
