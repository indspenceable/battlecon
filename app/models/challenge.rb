require 'online_game/game.rb'
class Challenge < ActiveRecord::Base
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
