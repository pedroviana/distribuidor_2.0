# encoding: UTF-8

ActiveAdmin.register User do
#  menu :if => proc{false}  

  index do
    selectable_column
    column :name
    column :email
    column :address
    column :state_and_city
    
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
        table_for user.user_events do |user_event|
          column 'Nome' do |user_event| 
            link_to user_event.event.title, admin_event_path(user_event.event)
          end
          
          column 'Data' do |user_event|
            user_event.event.datetime_formatted
          end
          
          column 'Confirmado?' do |user_event|
            user_event.presence_html
          end
        end
      else
        span do 
          "Nenhum Evento cadastrado para esse Usuário."
        end
      end
    end
  end
end
