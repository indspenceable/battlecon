class CharactersController < ApplicationController
  
  before_filter :require_login!
  
  def show
    @character = Character.find(params[:id])
    others = Character.where('id != ?', params[:id])
    @best_matchup = others.inject do |memo, char|
      break memo if @character.win_percent(:vs => char).nan?
      @character.win_percent(:vs => memo) > @character.win_percent(:vs => char) ? memo : char
    end
  end
  def matchup
    @character = Character.find(params[:id])
  end
end
