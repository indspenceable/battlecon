class Play < ActiveRecord::Base
  belongs_to :character
  validate :character_id, :presence => true
  belongs_to :player
  validate :player_id, :presence => true
  belongs_to :game
  validate :game_id, :presence => true
  
  validate :win, :null => false
  
  has_one :league, :through => :game
  scope :in_league, ->(l){joins(:game).where(:games =>{:league_id => l.is_a?(League) ? l.id : l})}
end
