class UserEvent < ActiveRecord::Base
  attr_accessible :id, :user_id, :event_id, :created_at, :updated_at, :presence, :status, :token, :user, :user_event_confirmation, :qr_code_scanned, :server_id, :event
  attr_accessor :user, :user_event_confirmation
  
  belongs_to :event
  belongs_to :user_relationship, :class_name => "User", :foreign_key => "user_id", :dependent => :delete
  
  has_one :user_event_confirmation_relationship, :class_name => "UserEventConfirmation", :foreign_key => "user_event_id", :dependent => :destroy
  
  has_many :reports, :dependent => :destroy
  
  validates_uniqueness_of :user_id, :scope => :event_id
  
  after_save do 
    create_user_event_confirmation
  end
  
  def info_complete
    presence
  end
  
  def create_user_event_confirmation
    return true unless user_event_confirmation
    
    user_event_confirmation['server_id'] = user_event_confirmation['id']
    user_event_confirmation.delete('id')
    
    existed_user_event_confirmation = UserEventConfirmation.find_by_server_id(user_event_confirmation['server_id']).update_attributes(user_event_confirmation) rescue nil
    user_event_confirmation_relationship = create_user_event_confirmation_relationship(user_event_confirmation) unless existed_user_event_confirmation
  end
  
  def presence_html
    presence ? '&#x2714;'.html_safe : '&#x2717;'.html_safe
  end
end
