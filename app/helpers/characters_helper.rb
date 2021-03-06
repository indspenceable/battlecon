module CharactersHelper
  def character_match_link player, match
    if player.won?(match)
      return link_to "(#{match.winning_player.name.titleize}) WON against #{match.losing_character.name.titleize} (#{match.losing_player.name.titleize})"
    else
      return link_to "(#{match.losing_player.name.titleize}) LOST to #{match.winning_character.name.titleize} (#{match.winning_player.name.titleize})"
    end
  end
  def character_vs_link match
    return link_to "(#{match.winning_player.name.titleize}) #{match.winning_character.name.titleize} WON against #{match.losing_character.name.titleize} (#{match.losing_player.name.titleize})"
  end
  
  def character_image_tag c, opts = {}
    image_tag("character-icons/#{c.name.downcase}.png", opts)
  end
end
