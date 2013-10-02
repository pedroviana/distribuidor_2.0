class AddIntergerServerIdAtEvents < ActiveRecord::Migration
  def up
    change_table(:events) do |t|
      t.integer :server_id
    end
  end

  def down
  end
end
