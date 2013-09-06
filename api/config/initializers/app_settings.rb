# encoding: UTF-8

require "unicode_utils/upcase"

class AppSettings
	class << self
	  def seconds_updated_at; 10; end;	  
    def only_sunday_id; 0; end;
    def only_monday_id; 1; end;
    def only_tuesday_id; 2; end;
    def only_wednesday_id; 3; end;
    def only_thursday_id; 4; end;
    def only_friday_id; 5; end;
    def only_saturday_id; 6; end;

		attr_accessor :mail_schedules

		# Schedules
		def mail_schedules
			if @mail_schedules.nil?
				@mail_schedules = Rufus::Scheduler.start_new
			end

			@mail_schedules
		end

		# Mail
		def failure_notification
			"Delivery Status Notification (Failure)"
		end

		def default_bounced_email
			"mailer-daemon@googlemail.com"
		end

		def mailer_sender
#			"interactivefan@interactivefan.com.br"
      "developer@dnacom.com.br"
		end

		def mailer_password
#			"w9y9h4bX1B"
      "ap050604"
		end	
		# Mail	

		# User Types
		def user_types
			#['Administrador', 'Analista', 'Usuário Cliente', 'Assessoria', 'iOS']
			['Administrador', 'Criador de Eventos', 'Criador de Convites']
		end

		def administrator
		  UnicodeUtils.upcase(user_types[0])
		end

		def ios
		  UnicodeUtils.upcase(user_types[3])
		end

		# Areas
		def areas
			['Tipo de Usuário', 'Usuário', 'Empresa', 'Relatório', 'Anexo', 'Notificação Push', 'Produto', 'Logs']
		end

		# Modules
		def project_modules
			['Módulo 1']
		end

    # this string is used to control all the national content
    def national_rule
      'Nacional'
    end

    # Type Values
    def type_values
    	['Texto', 'Anexo', 'Veiculação', 'Texto de Detalhe do Arquivo', 'Título']
    end

		# Attachmento Column
		def attachment_type_value_name
			type_values[1]
		end

		# Veiculação Column type
		def placement_type_value_name
			type_values[2]
		end

		# The Column type that shows on attachment details
		def attachment_detail_type_value_name
			type_values[3]
		end

		# Title of the attachment on device
		def title_attachment_type_value_name
			type_values[4]
		end

		def attachment_type_value_id
			TypeValue.find_by_name(type_values[1]).code rescue '0'
		end

		# Veiculação Column type
		def placement_type_value_id
			TypeValue.find_by_name(type_values[2]).code rescue '0'
		end

		def attachment_detail_type_value_id
			TypeValue.find_by_name(type_values[3]).code rescue '0'
		end		

		# Title of the attachment on device
		def title_attachment_type_value_id
			TypeValue.find_by_name(type_values[4]).code rescue '0'
		end		


    def ios_placement_values
			['Primeira Exibição', 'Reexibição']
    end

    def ios_new_placement_description
    	ios_placement_values[0]
    end

    def ios_old_placement_description
    	ios_placement_values[1]
    end

		def placement_values
			['Novo', 'Reveiculação']
		end

		def new_placement_description
			placement_values[0]
		end

		def old_placement_description
			placement_values[1]
		end

		def available_ids
			[available_id_of_the_day]
		end

		def available_id_of_the_day
			# 0 = sunday
			case Time.now.wday
			when 0
				only_sunday_id
			when 1
				only_monday_id
			when 2
				only_tuesday_id
			when 3
				only_wednesday_id
			when 4
				only_thursday_id
			when 5
				only_friday_id
			when 6
				only_saturday_id
			end
		end
	end

  class EmailTranslate < AppSettings
    class << self
      def welcome_pt; 'Bem-vindo'; end
      def welcome_en; 'Welcome'; end
      def welcome_; 'Welcome'; end
      
      def can_confirm_pt; "Você pode confirmar sua conta através do link abaixo:"; end
      def can_confirm_en; "You can confirm your account email through the link below:"; end
      def can_confirm_; "You can confirm your account email through the link below:"; end
        
      def confirm_label_link_pt; "Confirmar minha conta"; end
      def confirm_label_link_en; "Confirm my account"; end
      def confirm_label_link_; "Confirm my account"; end
        
      def password_label_pt; 'Sua senha é'; end
      def password_label_en; 'Your password is'; end
      def password_label_; 'Your password is'; end
      
      def download_label_link_pt; 'Você pode fazer o download do aplicativo utilizando o link abaixo em seu iPhone:';end
      def download_label_link_en; 'You can download the app through the link below:'; end
      def download_label_link_; 'You can download the app through the link below:'; end
        
      def new_password_pt; "Nova senha"; end
      def new_password_en; "New password"; end
      def new_password_; "New password"; end
    end
  end

  class Apple < AppSettings
    class << self
      def app_store_url
        ""
      end
    end
  end

	class Notifications < AppSettings
		class << self
			def new_clipping_custom_title(p_clipping)
				"Relatório #{p_clipping.title_pt} está disponível para você.|||#{p_clipping.title_en} Report is available for you"
			end

			def application_key
				"nvrhN8b9SEmIhvuxN_1VUg"
			end

			def application_secret
				"luutyf9aR7SuGFa3TdvhRA"
			end

			def master_secret
				"KTj8ATV6SnSvZ_Dn5Sv5IA"
			end

			# Urbanairship
			def set_urban_environment
				Urbanairship.application_key 	  = application_key
				Urbanairship.application_secret = application_secret
				Urbanairship.master_secret 		  = master_secret
				
				Urbanairship.logger = Rails.logger
				Urbanairship.request_timeout = 5 
			end
		end
	end
end