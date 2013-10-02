class AddServerIdToUsers < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.integer :server_id, :null => true
    end
  end
end
