class LeagueController < ApplicationController
  before_filter do
    session[:active_league_id] = params[:league_id] if params[:league_id]
  end
  
  def index
  end
  
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
  
end
