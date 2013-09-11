class UserEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  
  has_one :user_event_confirmation
  
  scope :without_token, -> {where("token = ?", "0")}
  scope :invited, -> {where("token != ?", "0")}
  scope :confirmed, -> {where("presence = 1")}
  
  def generate_token
    token = Devise.friendly_token.first(16)
    update_attribute(:token, token)
  end
  
  def confirm
    update_attribute(:presence, true)
  end
  
  def send_invite
    begin
      UserEventMailer.event_invite(self).deliver
    rescue Exception => e
      raise e.inspect
      reset_token
      return false
    end
  end
  
  def reset_token
    update_attribute(:token, '0')
  end
end
