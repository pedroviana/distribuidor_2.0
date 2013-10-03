# encoding: UTF-8

class Area < ActiveRecord::Base
  default_scope { order('title') }
  
  #attr_accessible *column_names
  
  def code
    read_attribute('id')
  end
end
