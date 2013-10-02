# encoding: UTF-8

class What < ActiveRecord::Base
  belongs_to :user
  attr_accessible :status

	validates_uniqueness_of :user_id
  validates_presence_of :status, :message => "status não preenchido"
  validates_presence_of :user_id, :message => "user_id não preenchido"
end
