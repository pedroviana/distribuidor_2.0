# encoding: UTF-8

ActiveAdmin.register User do
  menu :if => proc { current_admin_user.can_access?( I18n.t('activerecord.models.user') ) rescue false }, priority: 3
  
  form :partial => 'form'
  
  filter :name
  filter :email
  filter :company
  filter :state
  filter :city

  member_action :undelete do
    revived_record = PaperTrail::Version.find(params[:id]).reify
    revived_record.dont_valid = true
    if (revived_record.save rescue false)
      PaperTrail::Version.find(params[:id]).destroy
      redirect_to admin_user_path(revived_record), notice: 'Recadastramento realizado com sucesso!' and return
    else
      errors = revived_record.errors.messages.to_a.map!{|x| "#{I18n.t("activerecord.attributes.#{revived_record.class.to_s.to_underscore}.#{x.first}")} #{x.last.first}" }.join('')
      redirect_to :back, :alert => "Ocorreu um problema ao recadastrar: #{errors}" and return
    end
  end
  
  member_action :undelete_user_event do
    revived_record = PaperTrail::Version.find(params[:id]).reify
    if (revived_record.save rescue false)
      PaperTrail::Version.find(params[:id]).destroy
      redirect_to admin_user_path(revived_record.user), notice: 'Recadastramento realizado com sucesso!' and return
    else
      errors = revived_record.errors.messages.to_a.map!{|x| "#{I18n.t("activerecord.attributes.#{revived_record.class.to_s.to_underscore}.#{x.first}")} #{x.last.first}" }.join('')
      redirect_to :back, :alert => "Ocorreu um problema ao recadastrar: #{errors}" and return
    end
  end
  
  index do
    selectable_column
    column :name
    column :email
    column :company
    column "Estado/Cidade", :complete_city
    default_actions
  end
  
  show do |user|
    unavailable_fields = [
    ]

    new_fields = [
    ]

    attrs = user.attributes.keys.map(&:to_sym) - unavailable_fields
    attrs << new_fields
    attributes_table(*attrs.flatten)
    panel 'Eventos' do
      if user.user_events.count > 0
        table_for user.events do |event|
          column 'Nome' do |event| 
            link_to event.title, admin_event_path(event)
          end
          
          column 'Data' do |event|
            event.datetime_formatted
          end
        end
      else
        span do 
          "Nenhum Evento cadastrado para esse Usuário."
        end
      end
    end
  end
  
  controller do
    def create
      super
      @user.user_events.build
    end
    
    def update
      super
      @user.user_events.build
    end
    
#    def permitted_params
#      params.permit user: [:name, :email, :company, :event_ids => []]
#    end
  end
end
