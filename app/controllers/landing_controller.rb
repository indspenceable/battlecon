class LandingController < ApplicationController
  def index
    redirect_to dashboard_path if active_player
    @player = Player.new
  end
  
  def process_login
    auth = Player.find_by_name(params[:name].downcase).try(:authenticate, params[:password])
    if auth
      session[:player_id] = auth.id
      redirect_to dashboard_path, :flash => {:notice => "Successfully logged in."}
    else
      redirect_to login_path, :flash => {:error => "Incorrect username or password"}
    end
  end
  
  def logout
    logout!
    redirect_to login_path
  end
end
