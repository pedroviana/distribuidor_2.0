class AdminUserType < ActiveRecord::Base
  has_many :admin_user_type_areas
  has_many :areas, :through => :admin_user_type_areas
  
  accepts_nested_attributes_for :admin_user_type_areas

  validates_uniqueness_of :title
  
  default_scope { order('title') }
  
  def code
    read_attribute('id')
  end
  
  class << self
    def sync_event_id
      find_by_title(AppSettings.sync_event).read_attribute('id')      
    end
    
    def invitor_id
      find_by_title(AppSettings.invite_creator).read_attribute('id')      
    end
    
    def event_creator_id
      find_by_title(AppSettings.event_creator).read_attribute('id')
    end
    
    def administrator_id
      find_by_title(AppSettings.administrator).read_attribute('id')
    end
  end
end
