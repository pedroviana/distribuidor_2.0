# encoding: UTF-8

class UserEventConfirmationMailer < ActionMailer::Base
  default from: AppSettings.mailer_sender,
          return_path: AppSettings.mailer_sender
  
  #helper :application # gives access to all helpers defined within `application_helper`.

  def send_qr( record )
    attachments["convite.jpeg"] = File.read(record.qr_path)
	  @record = record
    @logo_image = "#{AppSettings.public_url}/logo_ford_mail.jpg"
    @line_image = "#{AppSettings.public_url}/barra_mail.jpg"
	 	mail(:to => record.user.email, :subject => "Sua presença no #{record.event.title} foi confirmada!")
	end
end
