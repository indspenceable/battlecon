class LeagueController < ApplicationController
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
    end.reject do |p|
      p.league != active_league
    end
  end
  
end
