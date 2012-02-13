class CreatePlays < ActiveRecord::Migration
  def change
    create_table :plays do |t|
      t.integer :player_id, :null => false
      t.integer :character_id, :null => false
      t.integer :game_id, :null => false
      
      t.boolean :win, :null => false

      t.timestamps
    end
  end
end
