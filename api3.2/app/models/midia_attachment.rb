# encoding: UTF-8

class MidiaAttachment < ActiveRecord::Base
  belongs_to :user_event_confirmation
  has_one :user_event, through: :user_event_confirmation
  has_one :user, through: :user_event
  has_one :event, through: :user_event
  
  attr_accessible *column_names
  
  has_attached_file :file,
    :path => ":rails_root/public/#{Rails.env}/:attachment/:id/:filename",
    :url => "/#{Rails.env}/:attachment/:id/:filename"
    
  def file_url
    file.url
  end
end
