require './player'
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
  def request_attack_pairs!
    pairs = {}
    2.times do
      raise InputRequiredException.new('Need attack pairs') if @input_buffer.empty? 
      inp = @input_buffer.slice!(0)
      pairs.[]=(*inp.split(':').map(&:to_sym))
    end
    pairs
  end
end

class Form
end

class Game
  def initialize previous_inputs = []

    @player1 = Player.new 1, 'p1'
    @player2 = Player.new 5, 'p2'
    @player1.opponent= @player2
    @player2.opponent= @player1
  end
  
  def run previous_inputs
    @input = InputFetcher.new(previous_inputs)
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
    pairs = @input.request_attack_pairs!
    @player1.attack_pair!(pairs[:p1b], pairs[:p1f])
    @player2.attack_pair!(pairs[:p2b], pairs[:p2f])
  end

  def ante
    # TODO
  end

  def reveal
    @player1.reveal!
    @player2.reveal!
  end

  def determine_active_player
    @active, @reactive = *(@player1.priority > @player2.priority ? [@player1,@player2] : [@player2,@player1])
  end

  def start_of_beat 
    @active.start_of_beat! @input
    @reactive.start_of_beat! @input
  end
  def activate activator
    puts "#{activator.name} is activating #{activator.base.class.name}"
    activator.before_activation! @input
    if activator.hits?
      puts "it's in range!"
      activator.on_hit! @input
      if activator.deal_damage > 0
        puts "and it dealt damage!"
        activator.on_damage! @input
      end
    end
    puts "Ok, after activation!"
    activator.after_activation! @input
  end
  
  def end_of_beat 
    @active.end_of_beat! @input
    @reactive.end_of_beat! @input
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
