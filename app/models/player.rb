require 'ratings'

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
  
  def rating
    EloRatings.get_elo_player(self.id).rating
  end
  
  has_many :league_memberships
  has_many :leagues, :through => :league_memberships
  
  belongs_to :active_league, :class_name => "League"
  validates :active_league, :presence => true, :unless => :new_league_name
  after_create do
    leagues << active_league
  end
  
  has_many :strategy_posts, :foreign_key => "creator_id"
  
  attr_accessor :new_league_name
  before_create do
    puts "New league name is #{new_league_name}"
    if new_league_name && !new_league_name.empty?
      self.active_league = League.create(:name => new_league_name)
    else
      false unless active_league
    end
  end
  
  has_secure_password
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password, :on => :create  
    
  before_save do
    self.name = self.name.downcase
    puts "password is ", self.password, " digest is ", self.password_digest
  end
end
