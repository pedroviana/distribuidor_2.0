class AddReferencesUserEventConfirmationInReports < ActiveRecord::Migration
  def up
    change_table(:reports) do |t|
      t.references :user_event_confirmation
    end
    
    add_index :reports, :user_event_confirmation_id
  end

  def down
  end
end
