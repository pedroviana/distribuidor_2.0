class CreateWhats < ActiveRecord::Migration
  def change
    create_table :whats do |t|
      t.references :user
      t.string :status

      t.timestamps
    end
    add_index :whats, :user_id
  end
end
