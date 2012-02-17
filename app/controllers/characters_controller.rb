class CharactersController < ApplicationController  
  def show
    @character = Character.find(params[:id])
  end
  def versus
    @character = Character.find(params[:character_id])
    @opponent = Character.find(params[:vs])
  end
end
