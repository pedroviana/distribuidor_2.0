# encoding: UTF-8

class AdminUser < ActiveRecord::Base
  has_paper_trail ignore: [:confirmed_at, :confirmation_sent_at, :generated_password, :id, :created_at, :updated_at, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :confirmation_token, :confirmed_at, :unconfirmed_email, :created_at, :updated_at]
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
         
  attr_accessible *column_names, :password, :password_confirmation, :skip_all_callbacks, :event_ids, :remember_me
  
  scope :administrators, -> { where(admin_user_type_id: AdminUserType.administrator_id) }
  scope :promoters, -> { where(admin_user_type_id: AdminUserType.event_creator_id) }
  scope :inviters, -> { where(admin_user_type_id: AdminUserType.invitor_id) }
  scope :sync_eventors, -> { where(admin_user_type_id: AdminUserType.sync_event_id) }
  
  scope :administradores, -> { administrators }
  scope :gerenciadores_de_convites, -> { inviters }
  scope :gerenciadores_de_eventos, -> { promoters }
  scope :sincronizadores, -> { sync_eventors }

  belongs_to :admin_user_type
  has_many :areas, :through => :admin_user_type

  has_many :admin_user_events, :dependent => :destroy
  has_many :events, :through => :admin_user_events, :uniq => true
  accepts_nested_attributes_for :admin_user_events

  cattr_accessor :event_name_shortcut, :skip_all_callbacks, :events_form_sync

  validates_presence_of :email, :name, :admin_user_type_id
  validate :password_complexity, :if => lambda { Rails.env.production? }
  
  before_validation :define_password, on: :create, if: :can_valid?

  before_update do
    unless self.confirmed_at.nil?
      self.generated_password = nil unless self.generated_password.nil?
    end
  end

  after_create do
    if can_valid?
      if event?
        # Create a event with the name given by the form and link this user with the event
        # create_event unless self.event_name_shortcut.to_s.empty?
      end 
      
      if administrator?
        Event.link_administrators(nil, self)
      end

=begin      
      if sync_event?
        events_form_sync.reject{|x| x.empty?}.each do |event_id|
          admin_user_events.create(event_id: event_id)
        end
      end
=end
    end
  end

  def password_complexity
    if password.present? and not password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).+/)
      errors.add :password, "é necessário que sua senha possua no mínimo 1 letra, 1 número e 1 letra maiúscula."
    end
  end

  def can_valid?
    skip_all_callbacks.nil?
  end

  ## Access >>>>
  def can_access?( p_area )
    return false if p_area.nil? 
    !self.areas.where("areas.title = ?", p_area).empty?
  end
  
  def title
    name
  end
  
  def code
    read_attribute('id')
  end
  
  def administrator?
    admin_user_type.title.upcase == AppSettings.administrator.upcase
  end
  
  def sync_event?
    admin_user_type.title.upcase == AppSettings.sync_event.upcase
  end
  
  def event?
    admin_user_type.title.upcase == AppSettings.event_creator.upcase
  end
  
  def inviter?
    admin_user_type.title.upcase == AppSettings.invite_creator.upcase    
  end
  
  private
  def define_password
    random_password = Devise.friendly_token.first(8)
    self.password = random_password
    self.password_confirmation = random_password
    self.generated_password = random_password
    return true
  end
  
  def create_event
    event = events.create(:title => event_name_shortcut)
    unless event.new_record?
      admin_user_events.create(:event => event)
    end
  end
end
