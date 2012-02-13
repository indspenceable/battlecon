class LandingController < ApplicationController
  
  def index
    redirect_to dashboard_path if active_player
    @player = Player.new
  end
  
  def logout
    session[:player] = nil
    redirect_to login_path
  end
end
