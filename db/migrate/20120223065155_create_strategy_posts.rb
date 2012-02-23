class CreateStrategyPosts < ActiveRecord::Migration
  def change
    create_table :strategy_posts do |t|
      t.integer :primary_character_id, :null => false
      t.integer :secondary_character_id, :null => true
      t.integer :creator_id, :null => false
      t.string :title
      t.text :text

      t.timestamps
    end
    add_index :strategy_posts, [:primary_character_id, :secondary_character_id], :name => "index_on_primary_character_id_seconardy_character_id"
    add_index :strategy_posts, :creator_id, :name => "index_on_creator_id"
  end
end
