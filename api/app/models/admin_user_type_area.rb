class AdminUserTypeArea < ActiveRecord::Base
  belongs_to :admin_user_type
  belongs_to :area
  
  def code
    read_attribute('id').to_i 
  end
end
