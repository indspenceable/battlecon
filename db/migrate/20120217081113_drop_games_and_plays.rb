class DropGamesAndPlays < ActiveRecord::Migration
  def change
    drop_table :games
    drop_table :plays
  end
end
