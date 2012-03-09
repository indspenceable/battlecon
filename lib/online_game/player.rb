require File.join(File.dirname(__FILE__), 'bases')
require File.join(File.dirname(__FILE__), 'forms')
require File.join(File.dirname(__FILE__), 'tokens')


class Player
  attr_reader :base, :form, :life, :name
  attr_accessor :opponent
  def initialize(input, position,name)
    @name = name
    @position = position
    @life = 20
    
    @bases = [
      Strike.new,
      Shot.new,
      Burst.new,
      Drive.new,
      Grasp.new,
      Dash.new
    ]
    @discard1 = []
    @discard2 = []
    
    @input = input
    @sources = []
  end
  def ante
    #By default, nothing happens during ante
  end
  
  def position
    @position
  end
  
  def possible_attack_pairs
    @forms.map do |f|
      @bases.map do |b|
        ["#{f.name}:#{b.name}"]
      end
    end.flatten
  end
  def attack_pair! f,b
    @form = @forms.detect {|c| c.name == f.to_s}
    raise RuntimeError.new("Don't have that form. #{f}") unless @form
    @base = @bases.detect {|c| c.name == b.to_s}
    raise RuntimeError.new("Don't have that base. #{b}") unless @base
    @bases.delete(@base)
    @forms.delete(@form)
    @sources << @base << @form
  end
  def sources
    @sources
  end
  def sum m
    sources.map(&m).inject(&:+)
  end
  def reveal!
    #nothing happens at reveal, yet
  end
  def priority
    sum :priority
  end

  def all_options_for(time)
    sources.map{|s| s.send(time).map{|o| "#{s.source}:#{o}"}}.flatten
  end
  
  [:start_of_beat,:before_activation,:on_hit,:on_damage,:after_activation,:end_of_beat].each do |time|
    define_method :"#{time}!" do
      while true
        options = all_options_for(time)
        return if options.empty?
        if options.size == 1
          abil,action = *options[0].split(':')
          self.send(abil).send(action,self,@input)
        else
          abil,action = *@input.request!(options).split(':')
          self.send(abil).send(action,self,@input)
        end
      end
    end
  end
  
  # ------ DASH DODGE EFFECT
  def dodged?
    @dodge
  end
  def dodge! tf=true
    @dodge = tf
  end
  
  def hits?
    in_range? unless @opponent.dodged?
  end
  
  def distance
    (position - @opponent.position).abs
  end
  
  # For each source, get its range as a Range or Nil.
  def range
    sources.inject(0..0) do |current_range, source|
      i = source.range
      return nil unless i
      modifier = (i.is_a?(Fixnum) ? (i..i) : i)
      (current_range.min + modifier.min)..(current_range.max + modifier.max)
    end
  end
  def in_range?
    range.include? distance if range
  end
  
  def direction
    (opponent.position - @position)/distance
  end
  
  def advance? n
    (position < 5 || (@opponent.position != 6)) &&
    (position > 1 || (@opponent.position != 0))
  end
  def retreat? n
    (0..6).include? @position - n*direction
  end
  def advance! n
    # We need to move past them if they are in our way
    if direction == 1
      if (@position += n) >= opponent.position
        @position += 1
      end
    else
      if (@position -= n) <= opponent.position
        @position -= 1
      end
    end
  end
  def retreat! n
    #we'll never pass them when retreating.
    @position -= n*direction
  end
  def push? n
    opponent.retreat? n
  end
  def push! n
    opponent.retreat! n
  end
  def pull? n
    opponent.advance? n
  end
  def pull! n
    opponent.advance! n
  end
  
  def deal_damage
    opponent.take_damage! sum(:power)
  end
  def take_damage! damage
    adjusted_damage = damage - soak
    adjusted_damage = 0 if adjusted_damage < 0
    @life -= adjusted_damage
    raise GameWonException.new(opponent) if @life <= 0
    if stuns? adjusted_damage
      stun!
    end
    adjusted_damage
  end
  
  def soak
    sum :soak
  end

  def recycle!
    @discard2.each{|x| gain! x}
    @discard2 = @discard1
    @discard1 = [@base,@form]
    @sources.delete(@base)
    @sources.delete(@form)
  end
  def gain! x
    @bases << x.class.new if x.is_a?(Base)
    @forms << x.class.new if x.is_a?(Form)   
  end
  
  def stun!
    @stunned = true
  end
  def stunned?
    @stunned
  end
  def stuns? damage
    damage > stun_guard
  end
  def unstun!
    @stunned = false
  end
  def stun_guard
    sum :stun_guard
  end
  def reset!
    unstun!
    dodge! false
  end
  
end
class Generic < Player
  def initialize *args
    super(*args)
    @forms = [
      NoForm.new,
      NoForm.new,
      NoForm.new
    ]
  end
end

class Cadenza < Player
  def initialize *args
    super(*args)
    @forms = [
      Clockwork.new,
      Grapnel.new,
      Mechanical.new,
      Hydraulic.new,
      Battery.new
    ]
    @bases << Press.new
    @iron_body_token_count = 3
  end
  def ante
    @iron_body = false
  end

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
  
  def end_of_beat!
    @sources.delete_if do |t|
      puts "Removing token #{t}: #{t.is_a?(Token)}"
      t.is_a?(Token)
    end
    super
  end
end
