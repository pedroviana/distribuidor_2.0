# encoding: UTF-8

class UserEventConfirmationMailer < ActionMailer::Base
  default from: AppSettings.mailer_sender,
          return_path: AppSettings.mailer_sender
  
  #helper :application # gives access to all helpers defined within `application_helper`.

  def send_qr( record )
	  @record = record
    @image      = "#{AppSettings.public_url}/header_pdf.png"
    @qr_code    = "#{AppSettings.public_url}/qrcodes/#{record.qr_path.split('/').last}"
    @latitude   = record.event.latitude
    @longitude  = record.event.longitude
    
    partial = render_to_string(:partial => 'invite', :layout => false)

    attachments["convite.pdf"] = PDFKit.new(partial).to_pdf

    @logo_image = "#{AppSettings.public_url}/logo_ford_mail.jpg"
    @line_image = "#{AppSettings.public_url}/barra_mail.jpg"

	 	mail(:to => record.user.email, :subject => "Sua presença no #{record.event.title} foi confirmada!")
	end
end
