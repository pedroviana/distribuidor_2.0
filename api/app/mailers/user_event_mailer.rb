class UserEventMailer < ActionMailer::Base
  default from: AppSettings.mailer_sender,
          return_path: AppSettings.mailer_sender
  
  #helper :application # gives access to all helpers defined within `application_helper`.

  def event_invite(user_event)
	  headers["Custom-header"] = "Bar"
	  @record = user_event
	 	mail(:to => user_event.user.email, :subject => "Você foi convidado para o Evento #{user_event.event.title}")
	end
end
