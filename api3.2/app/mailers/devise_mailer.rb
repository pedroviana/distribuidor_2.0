# encoding: UTF-8

class DeviseMailer < Devise::Mailer
  default from: AppSettings.mailer_sender,
          return_path: AppSettings.mailer_sender
  
  #helper :application # gives access to all helpers defined within `application_helper`.

  def new_password(resource, generated_password)
	  headers["Custom-header"] = "Bar"
	  @generated_password = generated_password
	  @resource = resource
	 	mail(:to => @resource.email, :subject => eval("AppSettings::EmailTranslate.new_password_#{record.language}"))
	end

  def confirmation_instructions(record, token, opts={})
    headers["Custom-header"] = "Bar"
    @record = record
    @token = token
    @logo_image = "#{AppSettings.public_url}/logo_ford_mail.jpg"
    @line_image = "#{AppSettings.public_url}/barra_mail.jpg"
	 	mail(:to => record.email, :subject => "Sua conta no Distribuidor 2.0 foi criada" )
  end
end
