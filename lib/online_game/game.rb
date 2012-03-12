require File.join(File.dirname(__FILE__), 'cadenza')
require File.join(File.dirname(__FILE__), 'hikaru')

require 'yaml'
module Online
  class InputRequiredException < RuntimeError;end
  class IncorrectAnswerException < RuntimeError;end
  class GameWonException < RuntimeError
    def initialize p
      super("#{p.name} won!")
    end
  end

  class InputFetcher
    def initialize prev
      @input_buffer = prev
      @pending_input = {}
    end
    def request! name,options
      @pending_input[name] = options
      raise Online::InputRequiredException.new(options.map{|o| "#{name}:#{o}"}.join(' ')) if @input_buffer.empty?
      me,option = @input_buffer.slice!(0).split(':',2)
      raise Online::IncorrectAnswerException.new(options.map{|o| "#{name}:#{o}"}.join(' ')) unless options.include?(option)
      @pending_input.delete(name)
      option
    end
    def multi_request! hsh
      responses = {}
      @pending_input = hsh.dup
      hsh.keys.count.times do
        raise Online::InputRequiredException.new("I need this input - #{hsh.reject{|k,v| responses.key? k}.inspect}") if @input_buffer.empty? 
        person,ans = *@input_buffer.slice!(0).split(':',2)
        raise Online::IncorrectAnswerException.new("Noone named #{person} was queried") unless hsh.key? person
        raise Online::IncorrectAnswerException.new("Already got an answer for #{person}") if responses.key? person
        raise Online::IncorrectAnswerException.new("#{person} tried invalid option #{ans} out of #{hsh[person]}") unless hsh[person].include?(ans)
        @pending_input.delete person
        responses[person] = ans
      end
      responses
    end
    def pending
      puts "PENDING INPUT"
      (@pending_input||{})
    end
  end

  class Game
    def setup previous_inputs = []
      @complete_input_list = previous_inputs.dup
      @input = InputFetcher.new(previous_inputs)
      @player1 = Cadenza.new @input, 1, 'p1'
      @player2 = Hikaru.new @input, 5, 'p2'
      @player1.opponent= @player2
      @player2.opponent= @player1
    end
    def inputs
      @complete_input_list || []
    end
    def pending_input n
      @input.pending[n]
    end
    def player_jsons
      puts "Got the jsons"
      return {'p1' => @player1.jsonify, 'p2' => @player2.jsonify}
    end
    
    #TODO this shouldn't be rescuing exceptions, instead, it should be
    # catching thrown symbols.
    def run previous_inputs
      setup previous_inputs
    
      15.times do |x|
        puts "-----------------------------"
        puts "Beat ##{x+1}"
        puts "Player one is at #{@player1.position} (#{@player1.life} / 20)"
        puts "Player two is at #{@player2.position} (#{@player2.life} / 20)"
        beat
      end
      puts "Life is #{@player1.life} vs #{@player2.life}"
      case @player1.life <=> @player2.life
      when 1
        raise GameWonException.new(@player1)
      when 0
        raise :lol
      else
        raise GameWonException.new(@player2)
      end
    end
  
    def beat
      reset
      planning
      ante
      reveal
      resolve_clash
      no_trigger
      determine_active_player
      start_of_beat
      activate @active unless @active.stunned?
      activate @reactive unless @reactive.stunned?
      end_of_beat
      recycle
    end
    def reset 
      @player1.reset!
      @player2.reset!  
    end
    def planning
      # pairs = @input.request_attack_pairs!
      # @player1.attack_pair!(pairs[:p1b], pairs[:p1f])
      # @player2.attack_pair!(pairs[:p2b], pairs[:p2f])
      pairs = @input.multi_request!('p1' => @player1.possible_attack_pairs, 'p2' => @player2.possible_attack_pairs)
      @player1.attack_pair!(*pairs['p1'].split(':'))
      @player2.attack_pair!(*pairs['p2'].split(':'))
    end

    def ante
      p,c = true,true
      cp,op = @player1,@player2
      loop do
        puts "ANTE PHASE"
        p = c
        c = cp.ante
        cp,op = op,cp
        return unless (p || c)
      end
    end

    def reveal
      @player1.reveal!
      @player2.reveal!
    end
    def no_trigger
      @player1.no_trigger!
      @player2.no_trigger!
    end

    def resolve_clash
      while @player1.priority == @player2.priority
        puts "****** CLASH at #{@player1.priority} Priority! ******"
        @player1.clash!
        @player2.clash!
        # both should select new bases
        new_bases = @input.multi_request!('p1' => @player1.base_names, 'p2' => @player2.base_names)
        @player1.resolve_clash! new_bases['p1']
        @player2.resolve_clash! new_bases['p2']
      end
      @player1.finalize_attack_pair!
      @player2.finalize_attack_pair!
    end

    def determine_active_player
      @active, @reactive = *(@player1.priority > @player2.priority ? [@player1,@player2] : [@player2,@player1])
    end

    def start_of_beat 
      @active.start_of_beat!
      @reactive.start_of_beat!
    end
    def activate activator
      puts "#{activator.name} is activating #{activator.base.class.name}"
      activator.before_activation!
      if activator.hits?
        puts "it's in range!"
        activator.on_hit!
        if activator.deal_damage > 0
          puts "and it dealt damage!"
          activator.on_damage!
        end
      end
      activator.after_activation!
    end
  
    def end_of_beat 
      @active.end_of_beat!
      @reactive.end_of_beat!
    end
  
    def recycle
      @active.recycle!
      @reactive.recycle!
    end

    def active
      @active
    end
    def reactive
      @reactive
    end
  end
end
