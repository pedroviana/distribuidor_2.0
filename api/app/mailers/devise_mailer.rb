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

  def confirmation_instructions(record, opts={})
    #record.confirmation_token = "#{record.confirmation_token}ppp#{record.generated_password}"
    headers["Custom-header"] = "Bar"
    @record = record
	 	mail(:to => record.email, :subject => "Sua conta no Distribuidor 2.0 foi criada" )
  end
  
  def confirmation_instructions_manual(record)
    headers["Custom-header"] = "Bar"
    @email = record.email
    @resource = record
	 	mail(:to => @email, :subject => eval("AppSettings::EmailTranslate.welcome_#{record.language}"))
  end
  
  def send_new_password(record, pass = nil)
    @email = record.email
    @password = pass
	 	mail(:to => @email, :subject => eval("AppSettings::EmailTranslate.new_password_#{record.language}"))
  end

  #def reset_password_instructions(record)
  #  super
  #end
end
