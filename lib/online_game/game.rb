require File.join(File.dirname(__FILE__), 'cadenza')
require File.join(File.dirname(__FILE__), 'hikaru')

require 'yaml'
module Online
  class InputFetcher
    attr_reader :issue, :message, :successful_input
    def initialize prev
      @input_buffer = prev
      @pending_input = {}
      @successful_input = []
      @issue = :none
      @message = nil
    end
    def input_required x
      @issue,@message = :input_required, x
      throw :input_required
    end
    def incorrect_answer x
      @issue,@message = :incorrect_answer, x
      #throw :incorrect_answer
      #We should maybe throw an error in this case.
    end
    
    def request! name,options
      @pending_input[name] = options
      
      input_required(options.map{|o| "#{name}:#{o}"}.join(' ')) if @input_buffer.empty?
      
      me,option = @input_buffer.first.split(':',2)
      
      incorrect_answer(options.map{|o| "#{name}:#{o}"}.join(' ')) unless options.include?(option)
      
      @pending_input.delete(name)
      @successful_input << @input_buffer.slice!(0)
      option
    end
    def multi_request! hsh
      responses = {}
      @pending_input = hsh.dup
      hsh.keys.count.times do
        input_required("I need this input - #{hsh.reject{|k,v| responses.key? k}.inspect}") if @input_buffer.empty? 
        
        person,ans = @input_buffer.first.split(':',2)
        
        incorrect_answer("Noone named #{person} was queried") unless hsh.key? person
        incorrect_answer("Already got an answer for #{person}") if responses.key? person
        incorrect_answer("#{person} tried invalid option #{ans} out of #{hsh[person]}") unless hsh[person].include?(ans)
        
        @pending_input.delete person
        @successful_input << @input_buffer.slice!(0)
        responses[person] = ans
      end
      responses
    end
    def pending
      (@pending_input||{})
    end
    def successful
      @successful_input
    end
  end

  class Game
    def character_names
      %w(hikaru cadenza)
    end
    def character_klass
      {
      'hikaru' => Hikaru,
      'cadenza' => Cadenza
      }
    end
    
    def output str
      @output << str
    end
    
    
    def setup previous_inputs = []
      @input = InputFetcher.new(previous_inputs)
      @output = []
      cs = @input.multi_request!('p1' => character_names, 'p2' => character_names)
      output "Player one is playing as #{cs['p1']}"
      output "Player two is playing as #{cs['p2']}"
      
      @player1 = character_klass[cs['p1']].new @input, 1, 'p1', @output
      @player2 = character_klass[cs['p2']].new @input, 5, 'p2', @output
      
      # @player1 = Cadenza.new @input, 1, 'p1'
      # @player2 = Hikaru.new @input, 5, 'p2'
      @player1.opponent= @player2
      @player2.opponent= @player1
      @winner = nil
    end
    def successful_inputs
      @input.successful_input
    end
    def pending_input n
      @input.pending[n]
    end
    def player_jsons n=0
      out = @output.last(@output.size - n) rescue []
      if @player1
        {
          'p1' => @player1.jsonify, 
          'p2' => @player2.jsonify,
          'winner' => (@winner ? @winner.name : nil),
          'log' => out
        }
      else
        {'winner' => nil, 'log' => out}
      end
    end
    
    def state
      if @winner
        :finished
      else
        @input.issue
      end
    end
    def message
      @input.message
    end
    
    #TODO this shouldn't be rescuing exceptions, instead, it should be
    # catching thrown symbols.
    def run previous_inputs
      catch :input_required do
        setup previous_inputs
        catch :ko do
          15.times do |x|
            output "Welcome to beat ##{x+1}"
            output "Player one is at #{@player1.position} (#{@player1.life} / 20)"
            output "Player two is at #{@player2.position} (#{@player2.life} / 20)"
            output "Life is #{@player1.life} vs #{@player2.life}"
            
            beat
          end
        end
        # Caught a KO, or played through the whole game.
        case @player1.life <=> @player2.life
        when 1
          @winner = @player1
        when 0
          @winner = :tie
        else
          @winner = @player2
        end
      end
      return self
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
      output "Player one selected attack pair: #{pairs['p1'].gsub(':',' ')}"
      output "Player two selected attack pair: #{pairs['p2'].gsub(':',' ')}"
      @player1.attack_pair!(*pairs['p1'].split(':'))
      @player2.attack_pair!(*pairs['p2'].split(':'))
    end

    def ante
      p,c = true,true
      cp,op = @player1,@player2
      loop do
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
        output "****** CLASH at #{@player1.priority} Priority! ******"
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
      output "#{activator.name} is activating #{activator.base.class.name}"
      activator.before_activation!
      if activator.hits?
        output "it's in range!"
        activator.on_hit!
        if activator.deal_damage > 0
          output "and it dealt damage!"
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
