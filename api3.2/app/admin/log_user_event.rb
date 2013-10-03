# encoding: UTF-8

ActiveAdmin.register_page "Log Cliente/Evento" do
  menu :if => proc {current_admin_user.can_access?( I18n.t('activerecord.models.logs') ) rescue false }, parent: 'Relatório'
  
  content do
		columns do
      column do
        # Normal records
        # Means that will handle only updates and creates
        panel "Últimas atividades" do

          # This block is responsible to remove the "repeated" updates 
          # that makes confusing of whats really going on with the record
          # ==============================================================
          # Reversing the array to show the most recent updates
      		#table_for last_changes.reverse do |p| 
      		
      		table_for PaperTrail::Version.where('item_type = "UserEvent"').order('created_at DESC').each do |p|
      		  
      		  # Column to show the user_event that make the changes
      		  # =============================================
        		column "Quem" do |p|
        		  user = PaperTrailModel.paper_trail_user(p)
        		  if user.is_a?(String)
        		    user
      		    else
      				  link_to user.title, admin_user_path(user)
    		      end
        		end
      		  # =============================================

      		  # Column to show the action made
      		  # ==============================
        		column "Ação" do |p|
        			PaperTrailModel.audit_action(p.event)
        		end
      		  # ==============================

      		  # Column to show the record updated
      		  # =================================
        		column "O que" do |p|
        		  record = eval("#{p.item_type}.find(#{p.item_id})") rescue nil
        		  if record
        			  link_to record.title, admin_user_path(record) 
      			  elsif p.event == 'destroy'
                 p.reify.title
      			  else
      			    "Não encontrado"
    			    end
        		end
      		  # =================================

            # Column to show the list of the attributes record updated
            # Show the old values or the current values that already been created
            # ===================================================================
        		column "De" do |p|
        			append = []
        			p.changeset.each do |key, changes|
        			  value=nil
        			  if p.event == 'create'
        			    value = changes.last
      			    else
        			    value = changes.first
    			      end

        				field_name = I18n.t("activerecord.attributes.#{p.item_type.to_underscore}.#{key}")
        				append     << "<strong> #{field_name}:</strong> &nbsp;#{PaperTrailModel.correct_value(p.item_type.to_underscore.clone, key.clone, ( value.clone rescue value ))}"
        			end

        			append.join('<br>').html_safe
        		end        	
            # ===================================================================

            # Column to show the list of the attributes record updated
            # Show the new values
            # ========================================================
        		column "Para" do |p|
        			append = []
        			p.changeset.each do |key, value|
        				append << "#{PaperTrailModel.correct_value(p.item_type.to_underscore.clone, key.clone, ( value.last.clone rescue value.last ))}"# if p.action != 'create'
        			end

        			append.join('<br>').html_safe
        		end
            # ========================================================

            # Column to show date of the change
            # =================================
        		column "Quando" do |p|
        			p.created_at.strftime("%d/%m/%Y %H:%M:%S")
        		end
        		
        		column "Restaurar" do |p|
              link_to "#{p.reify.title}", undelete_user_event_admin_user_path(p) if p.event == 'destroy'
      		  end
            # =================================
        	end
        end     
      end
    end
  end
end