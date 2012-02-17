class Character < ActiveRecord::Base
  has_many :plays
  has_many :games, :through => :plays
  
  def wins
    plays.where(:win => true)
  end
  def losses
    plays.where(:win => false)
  end
  
  def games_against(other_character, in_league = nil)
    if self == other_character
      games.group_by(&:id).reject{|num,game| num != 2}.map{|num,games| games.first}
    else
      if in_league
        games.where(:league_id => in_league.id) & other_character.games.where(:league_id => in_league.id)
      else
        games & other_character.games
      end
    end
  end
  
  def wins_against(other_character, in_league = nil)
    plays_against(other_character,in_league).where(:win => true)
  end
  def losses_against(other_character,in_league = nil)
    plays_against(other_character,in_league).where(:win => false)
  end
  
  def win_percent(opts = {})
    vs = opts[:vs]
    in_league = opts[:league]
    if vs
      wins_against(vs,in_league).count.to_f / plays_against(vs,in_league).count
    else
      wins.count / games.count rescue 0
    end
  end
  
  def best_matchup league=nil
    Character.where('id != ?', self.id).inject do |memo, char|
      next memo if self.win_percent(:vs => char, :league => league).nan?
      self.win_percent(:vs => memo, :league => league) > self.win_percent(:vs => char, :league => league) ? memo : char
    end
  end
  
  private
  def plays_against o, in_league=nil
    plays.where(:game_id => games_against(o, in_league))
  end
end
