class CreateMidiaAttachments < ActiveRecord::Migration
  def change
    create_table :midia_attachments do |t|
      t.references :user_event_confirmation

      t.timestamps
    end
    add_index :midia_attachments, :user_event_confirmation_id
  end
end
