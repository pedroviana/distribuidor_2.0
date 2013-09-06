class AdminUserType < ActiveRecord::Base
  has_many :admin_user_type_areas
  has_many :areas, :through => :admin_user_type_areas
  
  accepts_nested_attributes_for :admin_user_type_areas

  validates_uniqueness_of :title
  
  default_scope order('title')
  
  def code
    read_attribute('id')
  end
end
