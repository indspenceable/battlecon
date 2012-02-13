class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :name

      t.timestamps
    end
    
    add_index :characters, :name, :unique => true, :name => "index_on_character_name"
  end
end
