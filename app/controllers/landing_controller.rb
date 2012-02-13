class LandingController < ApplicationController
  def index
    redirect_to dashboard_path if active_player
    @player = Player.new
  end
  
  def process_login
    session[:player_id] = Player.find_by_name(params[:name]).id
    redirect_to dashboard_path
  end
  
  def logout
    logout!
    redirect_to login_path
  end
end
