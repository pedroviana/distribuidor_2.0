class User < ActiveRecord::Base
  has_many :user_events, dependent: :destroy
  has_many :events, :through => :user_events
  
  validates_presence_of :name, :email, :events
  validates_uniqueness_of :email
  validates_format_of :email, :with => Devise.email_regexp
  
#  scope :without_events, -> {  }
 
  class << self
  end
  
  def code
    read_attribute('id')
  end
  
  def complete_city
    "#{state}/#{city}"
  end
end
