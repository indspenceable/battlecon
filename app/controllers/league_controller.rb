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
    
    
  end
  
end
