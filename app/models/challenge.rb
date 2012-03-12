require 'online_game/game.rb'
class Challenge < ActiveRecord::Base
  def submit_input! input
    #TODO - game.inputs()
    inputs = load_game.inputs
    puts "Got the inputs: #{inputs}"
    inputs << input
    puts "inptus is now #{inputs}"
    game = Online::Game.new
    exception = ""
    begin
      game.run(inputs)
    rescue Online::IncorrectAnswerException
      return false
    rescue Object => e
      puts "EXCEPTION IS #{e.to_s}"
      exception = e.to_s
    end
    gs = YAML.dump(game)
    
    update_attributes!(:game_state => gs)
    return exception
  end
  def load_game
    YAML.load(game_state)
  end
  def player_name p
    puts "I'm looking at #{p.id}"
    puts "and my ids are #{player1_id} and #{player2_id}"
    case p.id
    when player1_id
      return 'p1'
    when player2_id
      return 'p2'
    else
      nil
    end
  end
  def pending_input p
    load_game.pending_input player_name(p)
  end
end
