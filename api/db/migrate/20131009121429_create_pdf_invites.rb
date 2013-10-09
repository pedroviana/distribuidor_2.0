class CreatePdfInvites < ActiveRecord::Migration
  def change
    create_table :pdf_invites do |t|
      t.references :user_event_confirmation

      t.timestamps
    end
    add_index :pdf_invites, :user_event_confirmation_id
    
    add_attachment :pdf_invites, :invite
  end
end
