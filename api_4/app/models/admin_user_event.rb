class AdminUserEvent < ActiveRecord::Base
  belongs_to :admin_user
  belongs_to :event

  #validates_presence_of :event, :admin_user_id
  
  validates_uniqueness_of :admin_user_id, :scope => :event_id, :message => "Usuário já pertence a esse Evento.s"
end
