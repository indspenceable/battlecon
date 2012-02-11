class CreatePlays < ActiveRecord::Migration
  def change
    create_table :plays do |t|
      t.integer :player_id
      t.integer :character_id
      t.integer :game_id
      
      t.boolean :win

      t.timestamps
    end
  end
end
