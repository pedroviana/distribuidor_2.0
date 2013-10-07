class UserEvent < ActiveRecord::Base
  has_paper_trail ignore: [:id, :created_at, :updated_at, :token]
  
  belongs_to :user
  belongs_to :event
  
  has_one :user_event_confirmation
  
  has_many :reports, dependent: :destroy
  has_many :invites, class_name: 'Report'
  has_many :presences, class_name: 'Report'
  
  scope :without_token, -> {where("token = ?", "0")}
  scope :invited, -> {where("token != ?", "0")}
  scope :confirmed, -> {where("presence = 1")}
  
  scope :invites, -> {where("type = ?", AppSettings.k_invite_report_schema)}
  scope :presences, -> {where("type = ?", AppSettings.k_presence_report_schema)}
  
  validates_presence_of :user_event_confirmation, :unless => Proc.new { user_event_confirmation.nil? }
  validates_uniqueness_of :user_id, :scope => :event_id
  
  after_update :check_presence
  
  def check_presence
    if presence_changed? and presence
      presences.create(schema: AppSettings.k_presence_report_schema)
    end
  end
  
  def generate_token
    token = Devise.friendly_token.first(16)
    update_attribute(:token, token)
  end
  
  def confirm
    write_attribute(:presence, true)
  end
  
  def send_invite
    begin
      UserEventMailer.event_invite(self).deliver
    rescue Exception => e
      reset_token
      return false
    end
  end
  
  def reset_token
    update_attribute(:token, '0')
  end
  
  def title
    "#{user.name rescue 'Usuário não encontrado'}/#{event.title rescue 'Evento não encontrado'}"
  end
end
