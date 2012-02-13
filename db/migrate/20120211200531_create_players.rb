class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name, :null => false
      t.integer :league_id

      t.timestamps
    end
    
    add_index :players, :name, :unique => true, :name => "index_on_player_name"
  end
end
