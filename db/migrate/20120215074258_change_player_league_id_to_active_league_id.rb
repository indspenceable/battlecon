class ChangePlayerLeagueIdToActiveLeagueId < ActiveRecord::Migration
  def change
    rename_column :players, :league_id, :active_league_id
  end
end
