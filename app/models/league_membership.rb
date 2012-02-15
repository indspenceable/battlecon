class LeagueMembership < ActiveRecord::Base
  belongs_to :player
  belongs_to :league
end
