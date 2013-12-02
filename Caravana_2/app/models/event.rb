# encoding: UTF-8
class Event < ActiveRecord::Base
  attr_accessible :address, :datetime, :title, :id, :created_at, :updated_at, :latitude, :longitude, :user_events, :server_id
  attr_accessor :user_events
  
#  scope :abertos, lambda {where :closed => false }
  
#  scope :fechados, lambda {where :closed => true }
  
  belongs_to :import
  has_many :user_events_relationships, :class_name => "UserEvent", :foreign_key => :event_id, :dependent => :destroy
  has_many :user_relationships, :through => :user_events_relationships
  
  after_save :create_user_events
  
  before_create do
#    self.closed = true
  end
  
  def self.pending_users(event_id)
    Event.find(event_id).user_relationships.select{|x| !x.info_completed? || x.reports.count == 0 }
  end
  
  def self.pending_users_only_report(event_id)
    Event.find(event_id).user_relationships.select{|x| x.reports.count == 0 }
  end
  
#  def self.open_events(event_ids)
#    find(event_ids).each{|event| event.update_column(:closed, false) }
#  end
  
#  def self.close_events(event_ids)
#    find(event_ids).each{|event| event.update_column(:closed, true) }
#  end
  
  def self.export_events( event_ids )
    where("id IN(?)",event_ids).to_json(:include => [:user_events_relationships => {:include => [:user_relationship, :user_event_confirmation_relationship => {:include => [:report_relationship => {:methods => :file_url}] } ] } ] )
  end
  
  def create_user(p)
    user = p['user']
    mappings = {"id" => "server_id", "position" => "job", "address_number" => "number", "is_smartphone" => "smartphone", "sms_usage" => "sms_alert", "email_usage" => "email_alert", "celnumber" => "cel"}
    new_user_hash = Hash[user.map {|k, v| [mappings[k] || k, v] }]
    new_user_hash.delete('completed')

    if ( self.user_relationship.server_id == new_user_hash['server_id'] rescue false )
      self.user_relationship.update_attributes(new_user_hash)
    else
      self.user_relationship.destroy rescue nil
      #created_user = create_user_relationship(new_user_hash)
      User.create(new_user_hash)
    end
  end 
  
  def create_user_events
    [user_events].flatten.each do |p|
      create_user(p)
      
      p['server_id']  = p['id']
      p.delete('id')
      
      p['user_id']    = User.find_by_server_id(p['user_id']).code
      p['event_id']   = Event.find_by_server_id(p['event_id']).code
      p['created_at'] = Time.now

      UserEvent.transaction do
        begin
          user_event_created = UserEvent.find_by_server_id(p['server_id']).update_attributes(p) rescue nil
          user_event_created = user_events_relationships.create(p) unless user_event_created
        rescue Exception => e
          raise e.inspect
          puts e.inspect
        end
      end
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

#  def id=(p)
#    self.server_id=p
#  end

  def consolidate_midia
    users = user_relationships#.reject{|x| !(x.reports.count > 0)}

    return nil if users.empty?

    keys = users.first.attributes.keys.map!(&:to_sym) - [:created_at, :updated_at, :id, :report_not_done, :server_id] + [:created_at]
    keys.map!{|x| I18n.t("activerecord.attributes.user.#{x.to_s}") }

    user_header = keys
    
    user_header << ["Presença", "QRCode ou E-mail"]
    user_header.flatten!

    file = "public/consolidate_midia.csv"
    begin
      File.delete(file)
    rescue Errno::ENOENT
    end

    csv_text = File.read(Report.midia_report.file.path)
    csv = CSV.parse(csv_text, :headers => false)
    questions_headers = []
    csv.each do |row|
      #questions_headers = row.to_hash.keys if questions_headers.empty?
      questions_headers << row if questions_headers.empty?
    end

    CSV.open(file, "wb") do |csv|
      header = [user_header, questions_headers].flatten
      csv << header
      users.each do |x|
        answers = []

        if x.reports.midia_report
          csv_text = File.read(x.reports.midia_report.file.path)
          csv_survey = CSV.parse(csv_text, :headers => false)
          answers = csv_survey.last
        end

        x_event = x.user_events.where("event_id = ?", self.code).first
  
        if x_event.email_search
          email_or_qr_code_string = "E-mail"
        elsif x_event.qr_code_scanned
          email_or_qr_code_string = "QRCode"
        else
          email_or_qr_code_string = nil        
        end

        array = [
          x.name, 
          x.company, 
          x.email, 
          x.cep, 
          x.address, 
          x.state, 
          x.city, 
          x.cel, 
          x.smartphone_description, 
          x.job, 
          x.complement, 
          x.number, 
          x.image_usage_description, 
          x.sms_alert_description, 
          x.email_alert_description, 
          x.created_at.strftime("%d/%m/%Y"),
          (email_or_qr_code_string ? "Sim" : "Não"),
          email_or_qr_code_string,
          answers.flatten
        ].flatten

        csv << array
      end
      # ...
    end

    return file
  end
end
