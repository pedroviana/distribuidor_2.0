class CreateUserEvents < ActiveRecord::Migration
  def change
    create_table :user_events do |t|
      t.references :user, index: true
      t.references :event, index: true

      # "I" Invite
      t.string :status, :default => "I", :null => false
      t.string :token, :default => "0", :null => false
      t.boolean :presence, :default => false, :null => false

      t.timestamps
    end
  end
end
