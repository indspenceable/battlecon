class AddLinkToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :link, :string
  end
end
