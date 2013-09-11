ActiveAdmin.register User do
  form :partial => 'form'
  
  filter :name
  filter :email
  filter :company
  filter :state
  filter :city
  
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
            event.title
          end
          
          column 'Data' do |event|
            I18n.localize(event.datetime, :format => '%b %-d %Y, %H:%M')
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
    def permitted_params
      params.permit user: [:name, :email, :company, :event_ids => []]
    end
  end
end
