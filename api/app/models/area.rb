class Area < ActiveRecord::Base
  default_scope { order('title') }
  
  def code
    read_attribute('id')
  end
end
