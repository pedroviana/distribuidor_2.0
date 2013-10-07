class AddAttachmentToMidiaAttachments < ActiveRecord::Migration
  def change
    add_attachment :midia_attachments, :file
  end
end
