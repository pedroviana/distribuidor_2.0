# encoding: UTF-8

class DriverQueue < ActiveRecord::Base
	audited

  belongs_to :user
  attr_accessible :user_id, :no_show, :truck, :can_view

  validates_uniqueness_of :user_id
  validates_presence_of :user_id, :message => "user_id não preenchido"

  after_update do |variable|
  	
  end
end
