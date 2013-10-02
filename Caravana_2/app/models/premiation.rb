class Premiation < ActiveRecord::Base
	audited

  belongs_to :user
  attr_accessible :user_id, :delivered, :can_view
end
