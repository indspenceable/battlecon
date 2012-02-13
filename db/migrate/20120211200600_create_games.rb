class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :league_id

      t.timestamps
    end
    
    add_index :games, :league_id, :name => "index_on_game_league_id"
  end
end
