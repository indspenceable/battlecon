class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
  
  helper_method :active_player
  def active_player
    Player.find(session[:player_id]) if session[:player_id]
  end
  helper_method :active_league
  def active_league
    session[:active_league_id] ? League.find(session[:active_league_id]) : active_player.active_league rescue nil
  end
  
  helper_method :al
  def al 
    {:league_id => active_league.id}
  end
  
  def require_login!
    redirect_to login_path unless active_player
  end
  def require_league!
    redirect_to dashboard_path unless active_league
  end
  
  def logout!
    session[:player_id] = nil
  end
end
