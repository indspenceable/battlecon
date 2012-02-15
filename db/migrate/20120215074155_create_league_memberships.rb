class CreateLeagueMemberships < ActiveRecord::Migration
  def change
    create_table :league_memberships do |t|
      t.integer :player_id
      t.integer :league_id

      t.timestamps
    end
    add_index :league_memberships, [:player_id, :league_id], :unique => true, :name => "index_on_player_id_league_id"
    add_index :league_memberships, [:league_id, :player_id], :unique => true, :name => "index_on_league_id_player_id"
  end
end
