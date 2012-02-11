class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :league

      t.timestamps
    end
  end
end
