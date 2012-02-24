module LeagueHelper
  def title(t=nil)
    @title = t if t
    @title
  end
  
  def wins_color c1,c2
    #return '#FFF' if c1 == c2
    win_list = c1.wins.where(:losing_character_id => c2.id).where(:league_id => active_league.id)
    total = c1.matches_against(c2).where(:league_id => active_league.id)
    wins = (win_list.count + 0.0) / total.count
    return 'transparent' if wins.is_a?(Float) && wins.nan?
    
    
    wp = (wins - 0.5) * 2
    r,g,b = "FF","FF","AA"
    if wp <= 0
      g = ((wp+1) * 255).to_i.to_s(16)
      b = ((wp+1) * 255 * 2 / 3).to_i.to_s(16)
    else
      #g = ((wp) * 255).to_i.to_s(16)
      r = ((1 - wp) * 255).to_i.to_s(16)
      b = ((1 - wp) * 255 * 2 / 3).to_i.to_s(16)
    end
    
    # r = ((1-wins)*255).to_i.to_s(16)
    r = "0#{r}" if r.length == 1
    # g = (wins*255).to_i.to_s(16)
    g = "0#{g}" if g.length == 1
    b = "0#{b}" if b.length == 1
    # b = "00"
    
    return "##{r}#{g}#{b}"
  end
  
  def win_loss c1,c2
    total = c1.matches_against(c2).where(:league_id => active_league.id).count
    wins = c1.wins.where(:losing_character_id => c2.id, :league_id => active_league.id).count
    "#{wins} / #{total - wins}"
  end
end
