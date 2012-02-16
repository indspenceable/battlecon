module LeagueHelper
  def title(t=nil)
    @title = t if t
    @title
  end
  
  def wins_color c1,c2,league
    return '#FFF' if c1 == c2
    win_list = c1.wins_against(c2,league)
    total = c1.games_against(c2,league)
    wins = (win_list.count + 0.0) / total.count
    return '#77c' if wins.is_a?(Float) && wins.nan?
    
    r = ((1-wins)*255).to_i.to_s(16)
    r = "0#{r}" if r.length == 1
    g = (wins*255).to_i.to_s(16)
    g = "0#{g}" if g.length == 1
    b = "00"
    
    return "##{r}#{g}#{b}"
  end
  
  def win_loss c1,c2, league=nil
    total = c1.games_against(c2,league).count
    wins = c1.wins_against(c2,league).count
    "#{wins} / #{total-wins}"
  end
end
