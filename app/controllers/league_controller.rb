class LeagueController < ApplicationController
  def index
    if params[:id] && active_player && active_player.league_ids.include?(params[:id])
      active_player.active_league = params[:id]
      redirect_to :back
    else
      session[:active_league_id] = params[:id]
    end
  end
  
  before_filter :require_league!, :only => :rankings
  def rankings
    @most_wins_player = Player.all.inject do |memo, char|
      memo.wins.count > char.wins.count ? memo : char
    end
    
    @most_wins_character = Character.all.inject do |memo, char|
      memo.wins.count > char.wins.count ? memo : char
    end
    
    @ranked_players = EloRatings.players_by_rating.map do |i,r|
      [Player.find(i),r.rating]
    end.select do |p,r|
      p.leagues.include?(active_league)
    end
  end
  
  #params[:name]
  def join
    league = League.find_by_name(params[:name])
    active_player.leagues 
  end
end
