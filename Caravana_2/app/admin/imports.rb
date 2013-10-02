ActiveAdmin.register Import do  
  config.comments = false

  show do
    if import.parse_file
      flash.now[:notice] = 'Aeeeeeeeee'
    else
      flash.now[:notice] = 'neeeem'      
    end
    
    unavailable_fields = [
    ]

    new_fields = [
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
