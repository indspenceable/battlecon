class MatchesController < ApplicationController
  before_filter :require_login!
  def new
    @match = Match.new(:creator => active_player.id, :creator_name => active_player.name)
    @opponents = active_league.players - [active_player]
  end
  def create
    @match = Match.new(params[:match]) do |m|
      m.league_id = active_league.id
    end
    @opponents = active_league.players - [active_player]
    if @match.save
      redirect_to dashboard_path, :flash => {:notice => "Match successfuly recorded."}
    else
      render :new
    end
  end
end
