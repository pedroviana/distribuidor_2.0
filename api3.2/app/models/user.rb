# encoding: UTF-8

class User < ActiveRecord::Base
  has_paper_trail ignore: [:id, :created_at, :updated_at]
  
  #attr_accessible *column_names, :dont_valid, :event_ids, :user_events_attributes
  
  attr_accessor :dont_valid
  
  has_many :user_events, dependent: :destroy
  has_many :reports, :through => :user_events
  has_many :invites, :through => :user_events
  has_many :presences, :through => :user_events
  accepts_nested_attributes_for :user_events
  
  has_many :events, :through => :user_events
  
  validates_presence_of :name, :email
  validates_presence_of :events, :unless => :dont_valid
  validates_uniqueness_of :email
  validates_format_of :email, :with => Devise.email_regexp
  
#  scope :without_events, -> {  }
 
  class << self
    def log_versions
      all.select{|x| !x.versions.empty? } 
    end
  end
  
  def code
    read_attribute('id')
  end
  
  def complete_city
    "#{state}/#{city}"
  end
  
  def title
    name
  end
end
