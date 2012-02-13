class Game < ActiveRecord::Base
  has_many :plays
  has_many :characters, :through => :plays
  has_many :players, :through => :plays
  
  belongs_to :league
  validate :league_id, :presence => true
  
  attr_accessor :creator_name # ignored
  attr_accessor :creator
  attr_accessor :creator_character
  attr_accessor :opponent
  attr_accessor :opponent_character
  attr_accessor :winner
  
  after_create do
#    if self.creator
      Play.create(:player => Player.find(self.creator), :game => self, :character_id => self.creator_character, :win => winner == "1")
#    end
#    if self.opponent
      Play.create(:player => Player.find(self.opponent), :game => self, :character_id => self.opponent_character, :win => winner == "0")      
#    end
  end
  
  def self.play(cn1,cn2)
    c1 = Character.find_by_name(cn1)
    c2 = Character.find_by_name(cn2)
    g = Game.create
    Play.create(:player_id => 1, :character => c1, :game => g, :win => true)
    Play.create(:player_id => 2, :character => c2, :game => g, :win => false)
  end
end
