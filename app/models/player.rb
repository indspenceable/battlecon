class Player < ActiveRecord::Base
  has_many :wins, :class_name => "Match", :foreign_key => :winning_player_id
  has_many :losses, :class_name => "Match", :foreign_key => :losing_player_id
  def matches
    Match.where('winning_player_id = ? OR losing_player_id = ?', self.id, self.id)
  end
  def won? match
    match.winning_player_id == self.id
  end
  def lost? match
    match.losing_player_id == self.id
  end
  
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
end
