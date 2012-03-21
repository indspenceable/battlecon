class ChallengesController < ApplicationController
  def index
    @challenges = Challenge
  end
  def show
    @challenge = Challenge.find(params[:id])
    if params[:format] == 'json'
      return render :json => @challenge.load_game.player_jsons().merge({:pending_input => @challenge.pending_input(active_player)})
    end
  end
  def update
    @challenge = Challenge.find(params[:id])
    pl = @challenge.player_name active_player
    #return render :json => {success: false, @challenge.load_game, output: Challenge.find(params[:id]).load_game.inputs.join(', ')} unless pl
    return unless (pl && @challenge.load_game.state != :finished)
    
    
    g = @challenge.submit_input!("#{pl}:#{params[:input]}")
    render :json => {success: true, game: @challenge.load_game.player_jsons.merge({:pending_input => @challenge.pending_input(active_player)})}
      #render :json => {success: false, output: Challenge.find(params[:id]).load_game.successful_inputs.join(', ')}
  end
  def create
    c = Challenge.new(params[:challenge])
    if c.save
      redirect_to c
    else
      flash[:error] = "Couldn't make challenge"
    end
  end
end
