class ChallengesController < ApplicationController
  def index
    @challenges = Challenge.all
  end
  def show
    @challenge = Challenge.find(params[:id])
  end
  def update
    @challenge = Challenge.find(params[:id])
    if x = @challenge.submit_input!(params[:input])
      render :json => {success: true, output: Challenge.find(params[:id]).load_game.inputs.join(', '), exception: x}
    else
      render :json => {success: false, output: Challenge.find(params[:id]).load_game.inputs.join(', ')}
    end
  end
end
