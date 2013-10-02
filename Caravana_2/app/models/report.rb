# encoding: UTF-8

class Report < ActiveRecord::Base
	audited

  #belongs_to :user_relationship, :class_name => "User", :foreign_key => 'user_id' 
  belongs_to :user_event#, :class_name => "UserEvent", :foreign_key => 'user_id'
  belongs_to :user_event_confirmation#, :class_name => "UserEventConfirmation"

  attr_accessible :what, :file, :user_event_confirmation_id, :created_at, :updated_at, :user_id
  
	has_attached_file :file, :url => "/csv/:what/:id/:filename", :path => ":rails_root/public/csv/:what/:id/:filename"

  validates_uniqueness_of :what, :scope => :user_event_id

	after_create do |r|
    r.user_event.user_relationship.update_next_status
	end

  def user
    user_event.user_relationship || user_event_confirmation.user_event.user_relationship
  end

	def what_string
		self.what
	end

	def self.count_midia_report
		where("what = 'habitos_de_midia'").count
	end

	def self.midia_report
		where("what = ? AND file_file_size IS NOT NULL", 'habitos_de_midia' ).last
	end
end
