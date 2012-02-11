class Player < ActiveRecord::Base
  has_many :plays
  has_many :games, :through => :plays
  
  belongs_to :league
  validate :league_id, :presence => true
  
end
