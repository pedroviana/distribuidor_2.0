class AdminUserTypeArea < ActiveRecord::Base
  belongs_to :admin_user_type
  belongs_to :area
  
  validates_uniqueness_of :admin_user_type_id, :scope => :area_id
  
  def code
    read_attribute('id').to_i 
  end
end
