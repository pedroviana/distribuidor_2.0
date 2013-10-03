# encoding: UTF-8

ActiveAdmin.register Event do
  menu :if => proc { current_admin_user.can_access?( I18n.t('activerecord.models.event') ) rescue false }, priority: 2
  
  #scope_to :current_admin_user
  
  filter :title
  filter :address
  filter :datetime

  member_action :undelete do
    revived_record = PaperTrail::Version.find(params[:id]).reify
    if (revived_record.save rescue false)
      PaperTrail::Version.find(params[:id]).destroy
      redirect_to admin_event_path(revived_record), notice: 'Recadastramento realizado com sucesso!' and return
    else
      errors = revived_record.errors.messages.to_a.map!{|x| "#{I18n.t("activerecord.attributes.#{revived_record.class.to_s.to_underscore}.#{x.first}")} #{x.last.first}" }.join('')
      redirect_to :back, :alert => "Ocorreu um problema ao recadastrar: #{errors}" and return
    end
  end

  action_item :only => :show, :if => proc { event.user_events.without_token.count > 0 and !current_admin_user.sync_event? } do
    link_to 'Enviar Convites', send_invites_admin_event_path(event)
  end

  batch_action :destroy, false
  
  batch_action 'Excluir ', :if => proc { !controller.current_admin_user.sync_event? and !controller.current_admin_user.inviter?}, :confirm => "Tem certeza de que deseja deletar?" do |selected_ids|
    Event.find(selected_ids).each { |r| r.destroy }

    redirect_to active_admin_config.route_collection_path(params),
                :notice => I18n.t("active_admin.batch_actions.succesfully_destroyed",
                                  :count => selected_ids.count,
                                  :model => 'evento',
                                  :plural_model => " eventos")
  end

  batch_action 'Download', :if => proc { controller.current_admin_user.sync_event? } do |selected_ids|
    path = "public/temp_event_#{Time.now}.json"
    begin
      File.delete(path)
    rescue Exception => e
    end
    
    File.open(path,"w") do |f|
      f.write(Event.export_events( selected_ids ))
    end
    
    send_file path
  end
  
  index do |event|
    selectable_column

    column :title
    column :address                
    column :datetime        
    column :created_at           
    column :updated_at 

    column 'Gerenciar' do |event|
      link_to 'Enviar Convites', send_invites_admin_event_path(event) if event.user_events.without_token.count > 0 and !current_admin_user.sync_event?
    end
    
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
    
    panels = [
      {label: 'Clientes não convidados', users: event.user_events.without_token}, 
      {label: 'Clientes convidados e não confirmados', users: event.user_events.invited - event.user_events.confirmed}, 
      {label: 'Clientes convidados e confirmados', users: event.user_events.confirmed}
    ]

    panels.each do |p|
      panel p[:label] do
        if p[:users].count > 0
          table_for p[:users].map(&:user) do |user|
            column 'Nome' do |user| 
              user.name
            end

            column 'Email' do |user| 
              user.email
            end
          end
        else
          span do 
            "Nenhum Cliente convidado para o Evento."
          end
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
    f.inputs "Detalhes" do
      f.input :title
      f.input :address
      f.input :datetime, :as => :just_datetime_picker
    end
    f.actions
  end

  member_action :send_invites do
    @event = Event.find params[:id] rescue nil
    if @event
      if @event.send_invites(current_admin_user)
        redirect_to admin_event_path(@event), notice: 'Convites enviados com sucesso!' and return
      else
        redirect_to admin_event_path(@event), :alert => 'Ocorreu um problema ao enviar os convites.' and return
      end
    else
      redirect_to admin_events_path, :alert => 'Evento não encontrado.' and return
    end
  end

  controller do
    def action_methods
      return super if current_admin_user.administrator? || current_admin_user.event?
      return ['index', 'batch_action'] if current_admin_user.sync_event?
      return super - ['edit', 'destroy'] if current_admin_user.inviter?
      return super
    end
    
    def create
      super 
      
      if !@event.new_record?
        if current_admin_user.event?
          current_admin_user.admin_user_events.create(:event => @event)
        end
      end
    end
    
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
#      def permitted_params
#        params.permit(:event => [:title, :address, :datetime, :datetime_date, :datetime_time_hour, :datetime_time_minute])
#      end
  end  
end
