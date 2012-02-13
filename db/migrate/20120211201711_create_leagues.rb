class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string :name

      t.timestamps
    end
    
    add_index :leagues, :name, :name => "index_on_league_name"
  end
end
