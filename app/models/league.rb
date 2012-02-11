class League < ActiveRecord::Base
  has_many :players
  has_many :games
end
