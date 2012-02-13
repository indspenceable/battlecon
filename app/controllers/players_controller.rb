class PlayersController < ApplicationController
  def create
    @player = Player.new(params[:player]) do |p|
      p.league_id = 1
    end
    if @player.save!
      session[:player_id] = @player.id
      redirect_to dashboard_path
    else
      render :text => "Did not create player."
    end
  end
  
  before_filter :require_login!, :only => :show
  
  def show
    @player = Player.find(params[:id])
  end
end
