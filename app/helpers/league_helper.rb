module LeagueHelper
  def title(t=nil)
    @title = t if t
    @title
  end
  
  def wins_color c1,c2
    win_list = c1.wins.where(:losing_character_id => c2.id).where(:league_id => active_league.id)
    total = c1.matches_against(c2).where(:league_id => active_league.id)
    wins = (win_list.count + 0.0) / total.count
    return 'transparent' if wins.is_a?(Float) && wins.nan?
    
    #TODO - use this to assign class, not style inline.
    case (wins * 10)
    when 0...2
      '#C33'
    when 2...4
      '#CC765B'
    when 4..6
      '#39A'
    when 6..8
      '#63C79C'
    else
      '#14CF14'
    end
    
    # fixed position on scroll down
    # popup with matchup helper
    # background on boxes
    # half sized portraits
    # Drag and drop for choosing matchups
    # add markdown for strategy posts.
  end
  
  def win_loss c1,c2
    total = c1.matches_against(c2).where(:league_id => active_league.id).count
    wins = c1.wins.where(:losing_character_id => c2.id, :league_id => active_league.id).count
    "#{wins} / #{total - wins}"
  end
end
