class AddBooleanClosedAtEvents < ActiveRecord::Migration
  def up
    change_table(:events) do |t|
      t.boolean :closed, :default => true
    end
  end

  def down
  end
end
