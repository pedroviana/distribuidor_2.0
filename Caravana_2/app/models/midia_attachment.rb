class MidiaAttachment < ActiveRecord::Base
  belongs_to :user_event_confirmation
  attr_accessible :id, :user_event_confirmation_id, :created_at, :updated_at, :file_file_name, :file_content_type, :file_file_size, :file_updated_at, :file_url
  has_attached_file :file,
    :path => ":rails_root/public/#{Rails.env}/:attachment/:id/:filename",
    :url => "/#{Rails.env}/:attachment/:id/:filename"
    
  def file_url
    file.url
  end
end
