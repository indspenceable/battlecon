class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :winning_player_id
      t.integer :losing_player_id
      t.integer :winning_character_id
      t.integer :losing_character_id
      t.integer :league_id

      t.timestamps
    end
    
    add_index :matches, [:winning_player_id]
    add_index :matches, [:losing_player_id]
    add_index :matches, [:winning_character_id]
    add_index :matches, [:losing_character_id]
    add_index :matches, [:league_id]
  end
end
