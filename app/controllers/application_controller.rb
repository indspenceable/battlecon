class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
  
  helper_method :active_player
  def active_player
    Player.find(session[:player_id]) if session[:player_id]
  end
  helper_method :active_league
  def active_league
    active_player.league
  end
  
  def require_login!
    redirect_to login_path unless active_player
  end
end
