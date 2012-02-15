class AddPasswordDigestToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :password_digest, :string, :null => false, :default => ""
  end
end
