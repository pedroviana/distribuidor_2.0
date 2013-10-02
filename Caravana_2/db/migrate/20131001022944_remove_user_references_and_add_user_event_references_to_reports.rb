class RemoveUserReferencesAndAddUserEventReferencesToReports < ActiveRecord::Migration
  def up
    remove_column :reports, :user_id
    
    change_table(:reports) do |t|
      t.references :user_event
    end
    
    add_index :reports, :user_event_id
  end

  def down
  end
end
