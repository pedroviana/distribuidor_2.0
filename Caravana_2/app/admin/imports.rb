ActiveAdmin.register Import do  
  config.comments = false

  index do
  end
  
  show do
    if import.parse_file
    end
    
    unavailable_fields = [
      :admin_user_id,
      :updated_at,
      :sync_file_name,
      :sync_content_type,
      :sync_file_size,
      :sync_updated_at,
      :parsed
    ]

    new_fields = [
      :admin_user,
      :parsed_html
    ]

    attrs = import.attributes.keys.map(&:to_sym) - unavailable_fields
    attrs << new_fields
    attributes_table(*attrs.flatten)
  end
  
  form do |f|                         
    f.inputs "Import" do       
      f.input :sync, as: :file
    end                               
    f.actions
  end
  
  controller do
    def create
      params[:import].merge!(:admin_user_id => current_admin_user.code).inspect
      super
    end
  end
end
