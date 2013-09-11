class Event < ActiveRecord::Base
  geocoded_by :address

  has_many :admin_user_events, :dependent => :destroy
  has_many :admin_users, :through => :admin_user_events
  
  has_many :user_events, :dependent => :destroy
  has_many :users, :through => :user_events

	validates_presence_of :title
  
  before_destroy :check_dependents
  
	after_validation :geocode, :if => lambda{ |obj| obj.address_changed? }
	
	after_create do
	  link_administrators
  end

  before_save :check_datetime
	
	acts_as_gmappable :process_geocoding => false
	
	just_define_datetime_picker :datetime#, :add_to_attr_accessible => true

  class << self
    # Get all the events that will happen
    # This method is used to manage the invites os the users/events
    def active_events_for_users
      t=Time.now
      time = Time.parse("#{t.day}/#{t.month}/#{t.year} 00:00:00") + 1.day - 3.hour
      where("datetime > ?", time)
    end
  end
	
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

  def send_invites
    user_events.without_token.includes(:user).each do |u|
      if u.generate_token and u.send_invite
      end
    end
  end

  def check_datetime	  
    tomorrow = ( Time.now.beginning_of_day + 1.day ).beginning_of_day
    errors.add :datetime , "Data muito próxima, no mínimo #{tomorrow.to_formatted_s(:long)}" if datetime < tomorrow
  end
	
	private
	def link_administrators
	  AdminUser.administrators.each do |admin_user|
	    admin_user_events.create(:admin_user => admin_user)
    end
  end
end

