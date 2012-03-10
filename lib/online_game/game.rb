require File.join(File.dirname(__FILE__), 'player')
require 'yaml'

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
  end
  def request! options
    raise InputRequiredException.new(options.join(' ')) if @input_buffer.empty?
    raise IncorrectAnswerException.new(options.join(' ')) unless options.include?(@input_buffer.first)
    @input_buffer.slice!(0)
  end
  def multi_request! hsh
    responses = {}
    2.times do
      raise InputRequiredException.new("I need this input - #{hsh.inspect}") if @input_buffer.empty? 
      person,ans = *@input_buffer.slice!(0).split(':',2)
      person = person.to_sym
      raise IncorrectAnswerException.new("Noone named #{person} was queried") unless hsh.key? person
      raise IncorrectAnsewrException.new("Already got an answer for #{person}") if responses.key? person
      raise IncorrectAnswerException.new("#{person} tried invalid option #{ans} out of #{hsh[person]}") unless hsh[person].include?(ans)
      responses[person] = ans
    end
    responses
  end
  
  def request_attack_pairs!
    pairs = {}
    4.times do
      raise InputRequiredException.new('Need attack pairs') if @input_buffer.empty? 
      inp = @input_buffer.slice!(0)
      pairs.[]=(*inp.split(':').map(&:to_sym))
    end
    pairs
  end
end

class Game
  def setup previous_inputs = []
    @input = InputFetcher.new(previous_inputs)
    @player1 = Cadenza.new @input, 1, 'p1'
    @player2 = Generic.new @input, 5, 'p2'
    @player1.opponent= @player2
    @player2.opponent= @player1
  end
  
  def run previous_inputs
    setup previous_inputs
    
    15.times do
      puts "-----------------------------"
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
    pairs = @input.multi_request!(:p1 => @player1.possible_attack_pairs, :p2 => @player2.possible_attack_pairs)
    @player1.attack_pair!(*pairs[:p1].split(':'))
    @player2.attack_pair!(*pairs[:p2].split(':'))
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

  def resolve_clash
    while @player1.priority == @player2.priority
      # both players should select new pairs.
    end
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
