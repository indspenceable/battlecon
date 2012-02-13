class CreatePlays < ActiveRecord::Migration
  def change
    create_table :plays do |t|
      t.integer :player_id, :null => false
      t.integer :character_id, :null => false
      t.integer :game_id, :null => false
      
      t.boolean :win, :null => false

      t.timestamps
    end
    
    add_index :plays, [:character_id,:win], :name => "index_on_play_character_id_and_wins"
    add_index :plays, [:character_id,:game_id], :unique => true, :name => "index_on_play_character_id_and_game_id"
    add_index :plays, [:character_id,:game_id,:win], :name => "index_on_play_character_id_game_id_and_wins"
    add_index :plays, [:player_id,:win], :name => "index_on_play_player_id"
    add_index :plays, :game_id, :name => "index_on_play_game_id"    
  end
end
