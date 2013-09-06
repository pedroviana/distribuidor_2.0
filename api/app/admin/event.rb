ActiveAdmin.register Event do
  menu :if => proc { current_admin_user.can_access?( I18n.t('activerecord.models.event') ) rescue false }
  
  filter :title
  filter :address
  filter :datetime
  
  index do |admin_user|
    selectable_column

    column :title
    column :address                
    column :datetime        
    column :created_at           
    column :updated_at 
    default_actions                   
  end
  
  show do |event|
    unavailable_fields = [
    ]

    new_fields = [

    ]

    attrs = event.attributes.keys.map(&:to_sym) - unavailable_fields
    attrs << new_fields
    attributes_table(*attrs.flatten)
    
    panel 'Clientes' do
      if event.users.count > 0
        table_for event.users do |user|
          column 'Nome' do |user| 
            user.name
          end
          
          column 'Email' do |user| 
            user.email
          end
        end
      else
        span do 
          "Nenhum Cliente cadastrado nesse Evento."
        end
      end
    end
    
    panel 'Mapa', :style => 'height: 500px' do 
      div :class => 'title_bar', :id => 'title_bar' do
        div :class => 'titlebar_left' do
          span do
            event.address
          end
        end
      end

      @location = [event].to_gmaps4rails
      if event.can_show_map?
        render "map", :location => @location
      end
    end
  end
  
  form do |f| 
    f.inputs "Details" do
      f.input :title
      f.input :address
      f.input :datetime, :as => :just_datetime_picker
    end
    f.actions
  end


  controller do
		def destroy
			@resource = Event.find params[:id] rescue nil
			
			redirect_to admin_events_path, :flash => {:error => "Evento não encontrado."} and return unless @resource 
			
      @resource.check_dependents
      
			@resource.destroy if @resource.errors[:base].empty?

			if @resource.destroyed?
				redirect_to admin_events_path
			else
				redirect_to admin_events_path, :flash => {:error => @resource.errors[:base].first}
			end 
		end
		  
    private
      # Using a private method to encapsulate the permissible parameters is
      # just a good pattern since you'll be able to reuse the same permit
      # list between create and update. Also, you can specialize this method
      # with per-user checking of permissible attributes.
      def permitted_params
        params.permit(:event => [:title, :address, :datetime, :datetime_date, :datetime_time_hour, :datetime_time_minute])
      end
  end  
end
