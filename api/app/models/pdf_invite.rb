class PdfInvite < ActiveRecord::Base
  belongs_to :user_event_confirmation
  attr_accessible :user_event_confirmation_id, :invite
  has_attached_file :invite,
    :path => ":rails_root/public/#{Rails.env}/:attachment/:id/:filename",
    :url => "/#{Rails.env}/:attachment/:id/:filename"
    
  after_save :check_user_event_confirmation_id
    
  def check_user_event_confirmation_id
    if user_event_confirmation.nil?
      destroy
    end
  end
    
  def file_url
    invite.url
  end
end
