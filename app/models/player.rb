class Player < ActiveRecord::Base
  has_many :plays
  has_many :games, :through => :plays
  
  belongs_to :league
  validate :league_id, :presence => true
  
  before_save do
    self.name = self.name.downcase
  end
  
  def wins
    plays.where(:win => true)
  end
  def losses
    plays.where(:win => false)
  end
  
end
