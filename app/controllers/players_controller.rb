class PlayersController < ApplicationController
  def create
    @player = Player.new(params[:player])
    if @player.save!
      session[:player_id] = @player.id
      redirect_to dashboard_path
    else
      render :text => "Did not create player."
    end
  end
    
  def show
    @player = Player.find(params[:id])
  end
end
