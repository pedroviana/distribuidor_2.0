class Event < ActiveRecord::Base
  geocoded_by :address

  has_many :user_events
  has_many :users, :through => :user_events

	validates_presence_of :title
  
  before_destroy :check_dependents
  
	after_validation :geocode, :if => lambda{ |obj| obj.address_changed? }
	
	acts_as_gmappable :process_geocoding => false
	
	just_define_datetime_picker :datetime#, :add_to_attr_accessible => true
	
	def check_dependents
	  if users.count > 0
		  errors[:base] << ("Existem Usuários vinculados nesse Evento.") 
	    false
    end
  end
	
	def can_show_map?
		!latitude.nil? and !longitude.nil?
	end
	
	def gmaps4rails_address
		"#{address}"
	end
end

