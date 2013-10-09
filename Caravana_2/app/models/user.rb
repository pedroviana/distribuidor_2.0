# encoding: UTF-8
require 'csv'

class User < ActiveRecord::Base
	audited

  attr_accessible :name,
                  :email,
                  :cep,
                  :address,
                  :state,
                  :city,
                  :cel,
                  :smartphone,
                  :job,
                  :image_usage,
                  :sms_alert,
                  :email_alert,
                  :report_not_done,
                  :company,
                  :complement,
                  :number,
                  :server_id,
                  :event_id,
                  :created_at, :updated_at, :celnumber

  attr_accessor :what_string, :event_id

  validates_uniqueness_of :email

  has_many :user_events, :dependent => :destroy
  has_many :events, :through => :user_events
  has_many :reports, :through => :user_events

  has_one :driver_queue, :dependent => :delete
  has_one :premiation, :dependent => :delete
  has_one :what, :dependent => :delete

  before_save do 
    if event_id
      event = Event.find(event_id) rescue nil
      if event
        user_events.build(:event => event) if user_events.where('event_id = ?', event_id).first.nil?
      end
    end
  end

  before_create do |u|
  	u.create_what
    u.build_premiation
    u.build_driver_queue
  end

  after_save do |u|
  	u.update_what
  end

  def truck_name
    driver_queue.truck
  end

  def create_what
  	build_what(:status => '')
  end

  def update_what
  	what.update_attribute(:status, what_string)
  end
  
  def info_completed?
    !(cep.nil? || cel.nil? || state.nil? || city.nil? || job.nil?)
  end
  
  def info_completed_json
    info_completed?
  end

  def what_name
  	next_status_string
  end

  def code
    read_attribute('id')
  end

  def update_next_status
    what.update_attribute(:status, next_status_string)
  end

  def next_status_string
    return 'cadastro' unless info_completed?
    
    w = ''

    case what.status
    when nil
      w = 'habitos_de_midia'
    when ''
      w = 'habitos_de_midia'
    when 'habitos_de_midia'
      w = 'finalizado'
    end
    
    w
  end

  def report_not_done_description
    return "" if self.report_not_done.nil?
    self.report_not_done ? "Sim" : "Não"
  end

  def image_usage_description
    return "" if self.image_usage.nil?
    self.image_usage ? "Sim" : "Não"
  end

  def sms_alert_description
    return "" if self.sms_alert.nil?
    self.sms_alert ? "Sim" : "Não"
  end

  def email_alert_description
    return "" if self.email_alert.nil?
    self.email_alert ? "Sim" : "Não"
  end
  
  def smartphone_description
    return "" if self.smartphone.nil?
    self.smartphone ? "Sim" : "Não"    
  end
  
  def state_and_city
    "#{state}/#{city}"
  end
  
  def replace(p)
    p.gsub!('Sunday', 'Domingo')
    p.gsub!('Monday', 'Segunda')
    p.gsub!('Tuesday', 'Terça')
    p.gsub!('Wednesday', 'Quarta')
    p.gsub!('Thursday', 'Quinta')
    p.gsub!('Friday', 'Sexta')
    p.gsub!('Saturday', 'Sábado')

    p
  end

  def formated_created_at(event_id)
    user_event  = user_events.where(event_id: event_id) rescue nil
    date        = (user_event.created_at.to_time - 3.hours ).strftime("Dia: %d, %A Mes: %m") rescue nil
    replace(date) rescue nil
  end
end
