class AddServerIdOnUserEventsAndChilds < ActiveRecord::Migration
  def up
    change_table(:user_events) do |t|
      t.integer :server_id
    end
    
    change_table(:user_event_confirmations) do |t|
      t.integer :server_id
    end
  end

  def down
  end
end
