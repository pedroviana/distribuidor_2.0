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
    
    path = "public/temp_pdf_invite_#{Time.now.to_i}.pdf"
    PDFKit.new(partial).to_file( path )
    @record.create_pdf_invite(invite: File.new( path ))
    File.delete(path)
    return false if @record.pdf_invite.new_record?
    
    @pdf_link = "#{AppSettings.public_url}#{@record.pdf_invite.file_url}"

    @logo_image = "#{AppSettings.public_url}/logo_ford_mail.jpg"
    @line_image = "#{AppSettings.public_url}/barra_mail.jpg"

	 	mail(:to => record.user.email, :subject => "Sua presença no #{record.event.title} foi confirmada!")
	end
end
