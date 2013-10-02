class CreatePremiations < ActiveRecord::Migration
  def change
    create_table :premiations do |t|
      t.references :user
      t.boolean :delivered, :default => false
      t.boolean :can_view, :default => false

      t.timestamps
    end
    add_index :premiations, :user_id
  end
end
