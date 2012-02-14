module CharactersHelper
  def win_loss_phrase b
    b ? "WON against" : "LOST to"
  end
  def game_link me, g
    p1,p2 = g.plays
    p2,p1 = p1,p2 if me == p2.character unless p1.character == p2.character
    link_to "(#{p1.player.name.titleize}) #{win_loss_phrase(p1.win)} #{p2.character.name.titleize} (#{p2.player.name.titleize})", g     
  end
end
