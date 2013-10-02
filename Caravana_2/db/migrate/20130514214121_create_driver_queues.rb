class CreateDriverQueues < ActiveRecord::Migration
  def change
    create_table :driver_queues do |t|
      t.references :user
      t.boolean :no_show, :default => false
      t.boolean :can_view, :default => false
      t.string :truck

      t.timestamps
    end
    add_index :driver_queues, :user_id
  end
end
