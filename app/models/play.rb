class Play < ActiveRecord::Base
  belongs_to :character
  validate :character_id, :presence => true
  belongs_to :player
  validate :player_id, :presence => true
  belongs_to :game
  validate :game_id, :presence => true
  
  belongs_to :league, :through => :game
end
