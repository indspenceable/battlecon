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
end
