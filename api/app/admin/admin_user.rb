ActiveAdmin.register AdminUser do
  menu parent: 'Usuário', :if => proc { current_admin_user.can_access?( I18n.t('activerecord.models.admin_user') ) rescue false }
  
  filter :email
  filter :name
  
  scope :administrators
  scope :promoters
  scope :inviters
  
  index do
    selectable_column
    column :email
    column :name
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
      :admin_user_type_id
    ]

    new_fields = [

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
    def permitted_params
      params.permit admin_user: [:name, :email, :admin_user_type_id, :event_name_shortcut]
    end
  end
end
