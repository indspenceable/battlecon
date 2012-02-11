class Game < ActiveRecord::Base
  has_many :plays
  has_many :characters, :through => :plays
  has_many :players, :through => :plays
  
  belongs_to :league
  validate :league_id, :presence => true
end
