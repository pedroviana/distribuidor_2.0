class Event < ActiveRecord::Base
  has_paper_trail ignore: [:latitude, :longitude, :id, :created_at, :updated_at]
  
  geocoded_by :address

  has_many :admin_user_events, :dependent => :destroy
  has_many :admin_users, :through => :admin_user_events
  
  has_many :user_events, :dependent => :destroy
  has_many :users, :through => :user_events

	validates_presence_of :title, :datetime, :address
	validates_uniqueness_of :title, scope: [:address, :datetime], message: 'Já existe um evento com o mesmo nome, endereço e data.'
  
  before_destroy :check_dependents
  
	after_validation :geocode, :if => lambda{ |obj| obj.address_changed? }
	
	after_create do
	  Event.link_administrators(self)
  end

  before_save :check_datetime
	
	acts_as_gmappable :process_geocoding => false
	
	just_define_datetime_picker :datetime#, :add_to_attr_accessible => true

  class << self
    # Get all the events that will happen
    # This method is used to manage the invites os the users/events
    def active_events_for_users
      select{|x| !x.is_late_for_invite? }
    end
    
    def export_events( event_ids )
      where("id IN(?)",event_ids).to_json(:include => [:user_events => {:include => [:user, :user_event_confirmation => {:include => [:midia_attachment => {:methods => :file_url}] } ] } ] )
    end
  end
  
  def is_late_for_confirmation?
    t = self.datetime
    !(Time.zone.now < Time.zone.parse("#{t.year}-#{t.month}-#{t.day} 20:00:00") - 1.day)
  end
  
  def is_late_for_invite?
    t = self.datetime
    !(Time.zone.now < Time.zone.parse("#{t.year}-#{t.month}-#{t.day} 18:00:00") - 1.day)
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

  def send_invites(current_admin_user)
    user_events.without_token.includes(:user).each do |u|
      if u.generate_token and u.send_invite
        u.invites.create(schema: AppSettings.k_invite_report_schema, admin_user: current_admin_user)
      end
    end
  end

  def check_datetime
    if datetime < Time.now
      errors.add :datetime , "Data não pode ser menor que a data atual." 
      return false
    else
      minimum_date = ( Time.now.beginning_of_day + 1.day ).beginning_of_day + 8.hour
      minimum_date_description = replace_en_month(minimum_date.strftime('%d de %B de %Y às %H:%M'))
      errors.add :datetime , "Data muito próxima, no mínimo #{minimum_date_description}" if datetime < minimum_date      
    end
  end
  
  def datetime_formatted
    replace_en_month(datetime.strftime('%d de %B de %Y às %H:%M')) rescue datetime
  end
  
  def replace_en_month(string)
    return string.gsub('January', 'Janeiro')     if string.match(/(?=January).+/)
    return string.gsub('February', 'Fevereiro')  if string.match(/(?=February).+/)
    return string.gsub('March', 'Março')         if string.match(/(?=March).+/)
    return string.gsub('April', 'Abril')         if string.match(/(?=April).+/)
    return string.gsub('May', 'Maio')            if string.match(/(?=May).+/)
    return string.gsub('June', 'Junho')          if string.match(/(?=June).+/)
    return string.gsub('July', 'Julho')          if string.match(/(?=July).+/)
    return string.gsub('August', 'Agosto')       if string.match(/(?=August).+/)
    return string.gsub('September', 'Setembro')  if string.match(/(?=September).+/)
    return string.gsub('October', 'Outubro')     if string.match(/(?=October).+/)
    return string.gsub('November', 'Novembro')   if string.match(/(?=November).+/)
    return string.gsub('December', 'Dezembro')   if string.match(/(?=December).+/)
  end

  def code
    read_attribute('id')
  end
	
	#private
	def self.link_administrators( event=nil, admin_user=nil )
	  if admin_user
	    [Event.all, event].flatten.compact.each do |event|
    	  admin_user.admin_user_events.create(event_id: event.code)
      end
    else
      AdminUser.administrators.each do |admin_user|
  	    if admin_user.admin_user_events.create(event_id: event.code)
	      end
      end
    end
  end
  
	def link_sync_eventors
	  AdminUser.sync_eventors.each do |admin_user|
	    admin_user.admin_user_events.create(event_id: code)
    end
  end
end

