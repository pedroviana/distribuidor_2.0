# encoding: UTF-8

ActiveAdmin.register Event do

  action_item :only => :show do
    link_to("Relatório", report_consolidate_admin_event_path(event))
  end
  
  member_action :report_consolidate, :method => :get do
    file = Event.find(params[:id]).consolidate_midia #rescue nil
    send_file file
  end

  batch_action :destroy, false

=begin
  batch_action "Iniciar Evento" do |selection|
    Event.open_events(selection)
    redirect_to admin_events_path, :notice => "Eventos iniciados com sucesso!"
  end

  batch_action "Encerrar Evento" do |selection|
    Event.close_events(selection)
    redirect_to admin_events_path, :notice => "Eventos encerrados com sucesso!"
  end
=end

  batch_action "Exportar Evento" do |selection|
    path = "public/temp_event_#{Time.now}.json"
    begin
      File.delete(path)
    rescue Exception => e
    end

    File.open(path,"w") do |f|
      f.write(Event.export_events( selection ))
    end

    send_file path
  end

  index do
    selectable_column
    column :title
    default_actions
  end
  
  show do
    unavailable_fields = [
      :import,
      :import_id
    ]

    new_fields = [
    ]

    attrs = event.attributes.keys.map(&:to_sym) - unavailable_fields
    attrs << new_fields
    attributes_table(*attrs.flatten)
  end
  
end
