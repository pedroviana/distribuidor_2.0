class MidiaAttachment < ActiveRecord::Base
  belongs_to :user_event_confirmation
  has_one :user_event, through: :user_event_confirmation
  has_one :user, through: :user_event
  has_one :event, through: :user_event
  
  has_attached_file :file,
    :path => ":rails_root/public/:attachment/:id/:filename",
    :url => "/:attachment/:id/:filename"
end
