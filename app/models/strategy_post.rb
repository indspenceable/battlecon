class StrategyPost < ActiveRecord::Base
  belongs_to :primary_character, :class_name => "Character"
  belongs_to :secondary_character, :class_name => "Character"
  belongs_to :creator, :class_name => "Player"
end
