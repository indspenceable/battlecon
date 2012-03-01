class LeaguesController < ApplicationController
  def index
    if params[:id] && active_player && active_player.leagues.map(&:id).include?(params[:id])
      active_player.active_league = params[:id]
      active_player.save
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
    league = League.find(params[:id])
    active_player.leagues << league
    active_player.active_league = league
    active_player.save
    flash[:success] = "Joined league successfully."
    redirect_to :back
  end
  
  def create
    league = League.new(:name => params[:name])
    if league.save
      active_player.leagues << league
      active_player.active_league = league
      active_player.save
      flash[:success] = "Created new league."
      redirect_to dashboard_path(:id => league.id)
    else
      flash[:error] = "Unable to create league."
      redirect_to :back
    end
  end
end
