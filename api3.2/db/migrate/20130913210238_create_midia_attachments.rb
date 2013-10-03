class CreateMidiaAttachments < ActiveRecord::Migration
  def change
    create_table :midia_attachments do |t|
      t.references :user_event_confirmation, index: true
      t.timestamps
    end
  end
end
