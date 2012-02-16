class Player < ActiveRecord::Base
  has_many :plays
  has_many :games, :through => :plays
  
  has_many :league_memberships
  has_many :leagues, :through => :league_memberships
  
  belongs_to :active_league, :class_name => "League"
  validates_presence_of :active_league
  after_create do
    league_memberships.create(:league => active_league)
  end
  
  has_secure_password
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password, :on => :create  
    
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
