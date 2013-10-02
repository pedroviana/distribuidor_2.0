class AddAttachmentToImports < ActiveRecord::Migration
  def change
  	add_attachment :imports, :sync
  end
end
