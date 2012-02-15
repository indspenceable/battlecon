class Player < ActiveRecord::Base
  has_many :plays
  has_many :games, :through => :plays
  
  belongs_to :league
  validate :league_id, :presence => true
  
  has_secure_password
  validates_presence_of :password, :on => :create
    
  before_save do
    self.name = self.name.downcase
    puts "password is ", self.password, " digest is ", self.password_digest
  end
  
  def wins
    plays.where(:win => true)
  end
  def losses
    plays.where(:win => false)
  end
  
end
