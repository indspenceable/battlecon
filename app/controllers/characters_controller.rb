class CharactersController < ApplicationController  
  def show
    @character = Character.find(params[:id])
    @post = StrategyPost.new(:primary_character_id => @character.id, :creator_id => active_player.id)
  end
  def versus
    @character = Character.find(params[:id])
    @vs = Character.find(params[:vs])
    @post = StrategyPost.new(:primary_character_id => @character.id, :secondary_character_id => @vs.id, :creator_id => active_player.id)
  end
end
