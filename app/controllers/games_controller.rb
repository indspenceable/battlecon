class GamesController < ApplicationController
  before_filter :require_login!
  def new
    @game = Game.new(:creator => active_player.id, :creator_name => active_player.name)
    @opponents = active_league.players - [active_player]
  end
  def create
    @game = Game.new(params[:game])
    @opponents = active_league.players - [active_player]
    if @game.save
      redirect_to dashboard_path, :flash => {:notice => "Match successfuly recorded."}
    else
      render :new
    end
  end
end
