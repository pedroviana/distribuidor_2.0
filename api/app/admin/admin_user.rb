# encoding: UTF-8

ActiveAdmin.register AdminUser do
  #menu parent: 'Usuário', :if => proc { current_admin_user.can_access?( I18n.t('activerecord.models.admin_user') ) rescue false }
  menu :if => proc { current_admin_user.can_access?( I18n.t('activerecord.models.admin_user') ) rescue false }, priority: 4
  
  filter :email
  filter :name
  
  scope :administradores
  scope :gerenciadores_de_eventos
  scope :gerenciadores_de_convites
  scope :sincronizadores
  
  member_action :undelete do
    revived_record = PaperTrail::Version.find(params[:id]).reify
    if (revived_record.save rescue false)
      PaperTrail::Version.find(params[:id]).destroy
      DeviseMailer.confirmation_instructions(revived_record, revived_record.generated_password, opts={}).deliver
      redirect_to admin_admin_user_path(revived_record), notice: 'Recadastramento realizado com sucesso!' and return
    else
      errors = revived_record.errors.messages.to_a.map!{|x| "#{x.first} #{x.last.first}" }.join('')
      redirect_to :back, :alert => "Ocorreu um problema ao recadastrar: #{errors}" and return
    end
  end
  
  index do
    selectable_column
    column :email
    column :name
    column :admin_user_type
    default_actions
  end

  form :partial => "form"
  
  show do |admin_user|
    unavailable_fields = [
      :event_name_shortcut,
      :password,
      :encrypted_password,
      :reset_password_token,
      :remember_created_at,
      :last_sign_in_ip,
      :current_sign_in_ip,
      :reset_password_sent_at,
      :confirmation_token,
      :unconfirmed_email,
      :current_sign_in_at,
      :last_sign_in_at,
      :admin_user_type_id,
      :generated_password
    ]
    
    if Rails.env.production?
      unavailable_fields << :generated_password
    end

    new_fields = [
      :admin_user_type
    ]

    attrs = admin_user.attributes.keys.map(&:to_sym) - unavailable_fields
    attrs << new_fields
    attributes_table(*attrs.flatten)
    
    panel 'Eventos' do
      if admin_user.events.count > 0
        table_for admin_user.events do |event|
          column 'Nome' do |event|
            link_to event.title, admin_event_path(event)
          end
          
          column 'Endereço' do |event|
            event.address
          end
        end
      else
        span do 
          "Nenhum Evento cadastrado nesse Usuário."
        end
      end
    end
  end
  
  controller do
#    def permitted_params
#      params.permit admin_user: [:name, :email, :admin_user_type_id, :event_name_shortcut, :events_form_sync => [], :event_ids => []]
#    end
  end
end
