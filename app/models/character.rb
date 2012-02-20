class Character < ActiveRecord::Base
  has_many :wins, :class_name => "Match", :foreign_key => :winning_character_id
  has_many :losses, :class_name => "Match", :foreign_key => :losing_character_id
  def matches
    Match.where('winning_character_id = ? OR losing_character_id = ?', self.id, self.id)
  end
  def won? match
    match.winning_character_id == self.id
  end
  def lost? match
    match.losing_character_id == self.id
  end
  
  def matches_against(other_character)
    if other_character == self
      Match.where(:winning_character_id => self.id, :losing_character_id => self.id)
    else
      matches.where('winning_character_id = ? OR losing_character_id = ?', other_character.id, other_character.id)
    end
  end
  
  def best_matchup league
    return Character.where('id != ?',id).inject do |memo, char|
      next memo if win_percent(char,league).nan?
      win_percent(memo, league) > win_percent(char,league) ? memo : char
    end
  end
  
  def win_percent c, league
    (wins.where(:losing_character_id => c.id).where(:league_id => league.id).count + 0.0) / matches_against(c).where(:league_id => league.id).count
  end
end
