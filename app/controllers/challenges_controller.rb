class ChallengesController < ApplicationController
  def index
    @challenges = Challenge.all
  end
  def show
    @challenge = Challenge.find(params[:id])
    g = @challenge.load_game
    if params[:format] == 'json'
      puts "i am player #{active_player.id}"
      return render :json => g.player_jsons.merge({:pending_input => @challenge.pending_input(active_player)})
    end
  end
  def update
    @challenge = Challenge.find(params[:id])
    pl = @challenge.player_name active_player
    return render :json => {success: false, output: Challenge.find(params[:id]).load_game.inputs.join(', ')} unless pl
    if x = @challenge.submit_input!("#{pl}:#{params[:input]}")
      render :json => {success: true, output: Challenge.find(params[:id]).load_game.inputs.join(', '), exception: x}
    else
      render :json => {success: false, output: Challenge.find(params[:id]).load_game.inputs.join(', ')}
    end
  end
end
