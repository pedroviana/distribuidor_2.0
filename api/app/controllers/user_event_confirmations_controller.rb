class UserEventConfirmationsController < ApplicationController
  def invalid_token

  end

  def update
    @user_event_confirmation = UserEventConfirmation.find params[:id] rescue nil
    if @user_event_confirmation
#      begin
        @user_event_confirmation.update_attributes(permitted_params)
#      rescue Exception => e
#        raise "#{e.inspect}"
#      end

    else
      redirect_to invalid_token_user_event_confirmations_path and return
    end
  end

  

  def show
    @user_event = UserEvent.find_by_token(params[:id]) rescue nil

    if @user_event
      @user_event_confirmation = @user_event.build_user_event_confirmation
      UserEvent.transaction do
#        begin
          if @user_event.confirm
          else
          end
#        rescue Exception => e
#          raise e.inspect
#        end
      end
    else
      flash.now[:notice] = "Token inválido."
      redirect_to invalid_token_user_event_confirmations_path and return
      #redirect_to change_password_admin_admin_user_path(current_admin_user), :alert => "É necessário alterar sua senha, por favor digite sua nova senha e a confirmação." and return
    end
  end

  private
    # Using a private method to encapsulate the permissible parameters is
    # just a good pattern since you'll be able to reuse the same permit
    # list between create and update. Also, you can specialize this method
    # with per-user checking of permissible attributes.
    def permitted_params
      params.require(:user_event_confirmation).permit(
                      :name,
                      :company,
                      :function,
                      :address,
                      :number,
                      :complement,
                      :cep,
                      :state,
                      :city,
                      :cellnumber,
                      :smartphone,
                      :image_usage,
                      :sms_usage,
                      :email_usage,
                      :le_revista,
                      :outra_revista,
                      :le_jornal,
                      :ouve_radio,
                      :tipo_musica,
                      :outra_radio,
                      :assisti_tv,
                      :frequencia_tv,
                      :canais_fechados,
                      :outros_canais,
                      :outro_preferido,
                      :envia_recebe_sms,
                      :usa_internet,
                      :frequencia_internet,
                      :outros_sites_noticias,
                      :outros_sites,
                      :acessa_redes_sociais,
                      :quais_blogs,
                      :visita_site_especializado,
                      :jornais_acres_outro, 
                      :jornais_alagoass_outro, 
                      :jornais_amazonass_outro, 
                      :jornais_bahias_outro, 
                      :jornais_cears_outro, 
                      :jornais_distrito_federals_outro, 
                      :jornais_esprito_santos_outro, 
                      :jornais_goiss_outro, 
                      :jornais_goinias_outro, 
                      :jornais_maranhos_outro, 
                      :jornais_mato_grosso_do_suls_outro, 
                      :jornais_minas_geraiss_outro, 
                      :jornais_parans_outro, 
                      :jornais_parabas_outro, 
                      :jornais_pars_outro, 
                      :jornais_pernambucos_outro, 
                      :jornais_piaus_outro, 
                      :jornais_rio_grande_do_nortes_outro, 
                      :jornais_rio_grande_do_suls_outro, 
                      :jornais_rio_de_janeiros_outro, 
                      :jornais_rondnias_outro, 
                      :jornais_roraimas_outro, 
                      :jornais_santa_catarinas_outro, 
                      :jornais_so_paulos_outro, 
                      :jornais_sergipes_outro,
                      :jornais => [],
                      :outro_site_especializado => [],
                      :revistas => [],
                      :radios => [],
                      :canais => [],
                      :programas_preferidos => [],
                      :tipo_internet => [],
                      :locais_internet => [],
                      :o_que_ve_internet => [],
                      :quais_redes_sociais => [],
                      :sites_especializados => [],
                      :jornais_acres => [], 
                      :jornais_alagoass => [], 
                      :jornais_amazonass => [], 
                      :jornais_bahias => [], 
                      :jornais_cears => [], 
                      :jornais_distrito_federals => [], 
                      :jornais_esprito_santos => [], 
                      :jornais_goiss => [], 
                      :jornais_goinias => [], 
                      :jornais_maranhos => [], 
                      :jornais_mato_grosso_do_suls => [], 
                      :jornais_minas_geraiss => [], 
                      :jornais_parans => [], 
                      :jornais_parabas => [], 
                      :jornais_pars => [], 
                      :jornais_pernambucos => [], 
                      :jornais_piaus => [], 
                      :jornais_rio_grande_do_nortes => [], 
                      :jornais_rio_grande_do_suls => [], 
                      :jornais_rio_de_janeiros => [], 
                      :jornais_rondnias => [], 
                      :jornais_roraimas => [], 
                      :jornais_santa_catarinas => [], 
                      :jornais_so_paulos => [], 
                      :jornais_sergipes => [], 
                      :outras_redes => []
                    )
    end
end
