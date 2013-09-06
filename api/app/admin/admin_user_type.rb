ActiveAdmin.register AdminUserType do
  menu parent: 'Usuário'
 
  config.filters = false
  
  form :partial => "form"

  show do |admin_user_type|
    unavailable_fields = [
    ]

    new_fields = [

    ]

    attrs = admin_user_type.attributes.keys.map(&:to_sym) - unavailable_fields
    attrs << new_fields
    attributes_table(*attrs.flatten)
    panel 'Áreas' do
      if admin_user_type.areas.count > 0
        table_for admin_user_type.areas do |area|
          column 'Nome' do |area| 
            area.title
          end
        end
      else
        span do 
          "Nenhuma área cadastrada para esse tipo de usuário usuário."
        end
      end
    end
  end
  
  controller do
    
    private
      # Using a private method to encapsulate the permissible parameters is
      # just a good pattern since you'll be able to reuse the same permit
      # list between create and update. Also, you can specialize this method
      # with per-user checking of permissible attributes.
      def permitted_params
        params.permit(:admin_user_type => [:title, :area_ids => []])
      end
  end
end
