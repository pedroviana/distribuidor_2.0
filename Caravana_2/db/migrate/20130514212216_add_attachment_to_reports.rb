class AddAttachmentToReports < ActiveRecord::Migration
  def change
  	add_attachment :reports, :file
  end
end
