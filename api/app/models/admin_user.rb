class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  scope :administrators, -> { where(admin_user_type_id: AdminUserType.administrator_id) }
  scope :promoters, -> { where(admin_user_type_id: AdminUserType.event_creator_id) }
  scope :inviters, -> { where(admin_user_type_id: AdminUserType.invitor_id) }

  belongs_to :admin_user_type
  has_many :areas, :through => :admin_user_type
  
  has_many :admin_user_events, :dependent => :destroy
  has_many :events, :through => :admin_user_events

  cattr_accessor :event_name_shortcut, :skip_all_callbacks

  before_validation :define_password, on: :create, if: :can_valid?
  
  validates_presence_of :email, :name, :admin_user_type

#  validate :password_complexity, :if => lambda { Rails.env.production? }

  after_create do 
    if can_valid?
      if event?
        # Create a event with the name given by the form and link this user with the event
        create_event unless self.event_name_shortcut.to_s.empty?
      end 
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
    admin_user_type.title == AppSettings.administrator
  end
  
  def event?
    admin_user_type.title.upcase == AppSettings.event_creator.upcase
  end
  
  private
  def define_password
    random_password = Devise.friendly_token.first(8)
#    write_attribute(:password, random_password)
#    write_attribute(:password_confirmation, random_password)
    self.password = random_password
    self.password_confirmation = random_password
  end
  
  def create_event
    event = events.create(:title => event_name_shortcut)
    unless event.new_record?
      admin_user_events.create(:event => event)
    end
  end
end
