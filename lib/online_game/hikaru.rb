require File.join(File.dirname(__FILE__), 'tokens')
require File.join(File.dirname(__FILE__), 'bases')
require File.join(File.dirname(__FILE__), 'forms')
require File.join(File.dirname(__FILE__), 'player')
module Online
  class Water < Token
    prop range: (-1..1)
  end
  class Fire < Token
    prop power: 3
  end
  class Wind < Token
    prop priority: 2
  end
  class Earth < Token
    prop soak: 3
  end

  def recover_token
    ->(me,input) do
      case me.spent_token_names.count
      when 0
        puts "no tokens to recover."
      when 1
        me.recover_token! me.spent_token_names.first
      else
        me.recover_token! input.request!(me.spent_token_names)
      end
    end
  end

  class Trance < Form
    prop range: (0..1), power: 0, priority: 0
    at :reveal, :fake, ->(me,input) do
      me.unante!
    end
    at :end_of_beat, :recover, recover_token
  end
  class Focused < Form
    prop range: 0, power: 0, priority: 1, stun_guard: 2
    at :on_hit, :recover, recover_token
  end
  class Geomantic < Form
    prop range: 0, power: 1, priority: 0
    at :start_of_beat, :ante_again, ->(me, input) do
      me.ante
    end
  end
  class Sweeping < Form
    prop range: 0, power: -1, priority: 3
    at :reveal, :suck, ->(me,input) do
      me.sweep!
    end
  end
  class Advancing < Form 
    prop range: 0, power: 1, priority: 1
    def power
      @passed ? 1 : 2
    end
    at :start_of_beat, :advance, ->(me,input) do
      initial_direction = me.direction
      select_from(advance:[1]).call(me,input)
      @passed = (initial_direction != me.direction)
    end
  end

  class PalmStrike < Base
    prop range: 1, power: 2, priority: 5
    at :start_of_beat, :advance, select_from(advance:[1])
    at :on_damage, :recover, recover_token
  end

  class Hikaru < Player
    def initialize *args
      super
      @forms = [
        Trance.new,
        Focused.new,
        Geomantic.new,
        Sweeping.new,
        Advancing.new
      ]
      @bases << PalmStrike.new
      @token_pool = [Fire.new, Water.new, Wind.new, Earth.new]
      @active_tokens = []
      @token_discard = []
    end
  
    def token_pool_names
      @token_pool.map(&:name)
    end
    def spent_token_names
      @token_discard.map(&:name)
    end
  
    def aux_sources
      @active_tokens
    end
    def ante_token! token_name
      puts "Trying to ante #{token_name}"
      token = @token_pool.find{|f| f.name == token_name}
      puts "Found #{token}"
      @active_tokens << token
      @token_pool.delete token
      puts "Selected #{token.name}"
    end
    def ante
      if @active_tokens.empty? && @token_pool.any?
        selection = @input.request!(token_pool_names + ['none'])
        return false if selection == 'none'
        ante_token! selection
      end
    end
    def unante!
      @token_pool += @active_tokens
      @active_tokens = []
    end
    def recover_token! x
      t = @token_discard.find{|y| y.name == x}
      @token_pool << t
      @token_discard.delete(t)
    end
    def reveal!
      @sweeping = false
      super
    end
    def sweep!
      @sweeping = true
    end
    def determine_damage d
      super(@sweeping ? d+2 : d)
    end
    def end_of_beat!
      super
      #after we've gotten the regain token effect, move them from active to discard
      @token_discard += @active_tokens
      @active_tokens = []
    end
  end
end