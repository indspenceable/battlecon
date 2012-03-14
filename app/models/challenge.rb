require 'online_game/game.rb'
class Challenge < ActiveRecord::Base
  scope :belonging_to, ->(pl){where('player1_id = ? OR player2_id = ?', pl.id, pl.id)}
  
  attr_accessor :player2_name
  
  before_create do
    if player2_name
      self.player2_id = Player.where(:name => player2_name).first.id
    end
    self.status = 'pending'
    self.game_state = YAML.dump(Online::Game.new.run([]))
  end
  
  
  def submit_input! input
    #TODO - game.inputs()
    inputs = load_game.successful_inputs
    inputs << input
    game = Online::Game.new.run(inputs)
    gs = YAML.dump(game)
    
    update_attributes!(:game_state => gs)
    game
  end
  def load_game
    YAML.load(game_state)
  end
  def re_run
    Online::Game.new.run(load_game.successful_inputs)
  end
  def player_name p
    case p.id
    when player1_id
      return 'p1'
    when player2_id
      return 'p2'
    else
      nil
    end
  rescue 
    nil
  end
  def pending_input p
    load_game.pending_input player_name(p)
  end
end
