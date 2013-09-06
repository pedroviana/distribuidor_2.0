class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
         
#  attr_accessible :email, :password, :password_confirmation, :admin_user_type_id

  belongs_to :admin_user_type
  has_many :areas, :through => :admin_user_type

  ## Access >>>>
  def can_access?( p_area )
    return false if p_area.nil? 
    !self.areas.where("areas.title = ?", p_area).empty?
  end
  
  def title
    name
  end
end
