class CharactersController < ApplicationController  
  def show
    @character = Character.find(params[:id])
    others = Character.where('id != ?', params[:id])
    @best_matchup = others.inject do |memo, char|
      next memo if @character.win_percent(:vs => char).nan?
      @character.win_percent(:vs => memo) > @character.win_percent(:vs => char) ? memo : char
    end
  end
  def matchup
    @character = Character.find(params[:id])
  end
end
