class CreateUserEvents < ActiveRecord::Migration
  def change
    create_table :user_events do |t|
      t.references :user
      t.references :event

      # "I" Invite
      t.string :status, :default => "I", :null => false
      t.string :token, :default => "0", :null => false
      t.boolean :presence, :default => false, :null => false

      t.timestamps
    end
    add_index :user_events, :user_id
    add_index :user_events, :event_id
  end
end
