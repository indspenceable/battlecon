class Match < ActiveRecord::Base
  belongs_to :winning_character, :class_name => "Character"
  belongs_to  :losing_character, :class_name => "Character"
  belongs_to :winning_player,    :class_name => "Player"
  belongs_to  :losing_player,    :class_name => "Player"
  scope :recent, order('created_at DESC').limit(10)
  
  
  
  attr_accessor :creator_name # ignored
  attr_accessor :creator
  attr_accessor :creator_character
  attr_accessor :opponent
  attr_accessor :opponent_character
  attr_accessor :creator_is_winner
  before_create do
    if creator_is_winner
      self.winning_character = Character.find creator_character
      self.winning_player = Player.find creator
      self.losing_character = Character.find opponent_character
      self.losing_player = Player.find opponent
    else
      self.losing_character = Character.find creator_character
      self.losing_player = Player.find creator
      self.winning_character = Character.find opponent_character
      self.winning_player = Player.find opponent
    end
  end
end
