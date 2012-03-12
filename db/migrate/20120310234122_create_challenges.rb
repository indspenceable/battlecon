class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.integer :player1_id
      t.integer :player2_id
      t.text :game_state
      t.string :status

      t.timestamps
    end
  end
end
