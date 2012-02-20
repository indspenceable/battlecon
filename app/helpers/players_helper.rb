module PlayersHelper
  def player_match_link player, match
    if player.won?(match)
      return link_to "#{match.winning_character.name.titleize} WON against #{match.losing_character.name.titleize} (#{match.losing_player.name.titleize})"
    else
      return link_to "#{match.losing_character.name.titleize} LOST to #{match.winning_character.name.titleize} (#{match.winning_player.name.titleize})"
    end
  end
end
