class CharactersController < ApplicationController  
  def show
    @character = Character.find(params[:id])
  end
  def versus
    @character = Character.find(params[:id])
    @vs = Character.find(params[:vs])
  end
end
