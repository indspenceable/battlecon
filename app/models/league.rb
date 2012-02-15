class League < ActiveRecord::Base
  has_many :league_memberships
  has_many :players, :through => :league_memberships
  has_many :games
end
