module CharactersHelper
  def character_match_link player, match
    if player.won?(match)
      return link_to "(#{match.winning_player.name.titleize}) WON against #{match.losing_character.name.titleize} (#{match.losing_player.name.titleize})"
    else
      return link_to "(#{match.losing_player.name.titleize}) LOST to #{match.winning_character.name.titleize} (#{match.winning_player.name.titleize})"
    end
  end
end
