# encoding: UTF-8

class UserEventConfirmationsController < ApplicationController
=begin
  layout :layout_by_action
  
  def layout_by_action
    if self.action_name == 'show'
      'application'
    else
      raise 'client'
      'client'
    end
  end
=end
  
  def invalid_token
  end
  
  def already_confirmed
  end
  
  def thanks
  end

  def user_for_paper_trail
    "Cliente"
  end
  
  def confirmations_closed
  end

  def create
    raise 'ae'
    @user_event = UserEvent.find_by_token params[:user_event_confirmation][:token] rescue nil
    if @user_event
      UserEvent.transaction do
        params[:user_event_confirmation].delete(:token)
        @user_event.build_user_event_confirmation(params[:user_event_confirmation])
        
        if @user_event.confirm and @user_event.save
          @user_event.user_event_confirmation.send_qr
          redirect_to thanks_user_event_confirmations_path and return          
        else
          redirect_to invalid_token_user_event_confirmations_path and return
        end
      end
    else
      flash.now[:notice] = "Token inválido."
      redirect_to invalid_token_user_event_confirmations_path and return
    end
  end

  def show
    @user_event = UserEvent.find_by_token(params[:id]) rescue nil

    if @user_event
      if !@user_event.event.is_late_for_confirmation?
        @user_event_confirmation=nil
        if @user_event.user_event_confirmation.nil?
          @user_event_confirmation = @user_event.build_user_event_confirmation
        else
          redirect_to already_confirmed_user_event_confirmations_path and return
        end
      else
        flash.now[:notice] = "Confirmações foram encerradas"
        redirect_to confirmations_closed_user_event_confirmations_path and return
      end
    else
      flash.now[:notice] = "Token inválido."
      redirect_to invalid_token_user_event_confirmations_path and return
    end
  end

  private
    # Using a private method to encapsulate the permissible parameters is
    # just a good pattern since you'll be able to reuse the same permit
    # list between create and update. Also, you can specialize this method
    # with per-user checking of permissible attributes.
=begin
    def permitted_params
      params.require(:user_event_confirmation).permit(
                      :tipo_musica_other, :outras_redes, :outro_site_especializado,
                      :blank_midia_attachment,
                      :name,
                      :company,
                      :function,
                      :address,
                      :number,
                      :complement,
                      :cep,
                      :state,
                      :city,
                      :celnumber,
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
                      :jornais_acres_other, 
                      :jornais_alagoass_other, 
                      :jornais_amazonass_other, 
                      :jornais_bahias_other, 
                      :jornais_cears_other, 
                      :jornais_distrito_federals_other, 
                      :jornais_esprito_santos_other, 
                      :jornais_goiss_other, 
                      :jornais_goinias_other, 
                      :jornais_maranhos_other, 
                      :jornais_mato_grosso_do_suls_other, 
                      :jornais_minas_geraiss_other, 
                      :jornais_parans_other, 
                      :jornais_parabas_other, 
                      :jornais_pars_other, 
                      :jornais_pernambucos_other, 
                      :jornais_piaus_other, 
                      :jornais_rio_grande_do_nortes_other, 
                      :jornais_rio_grande_do_suls_other, 
                      :jornais_rio_de_janeiros_other, 
                      :jornais_rondnias_other, 
                      :jornais_roraimas_other, 
                      :jornais_santa_catarinas_other, 
                      :jornais_so_paulos_other, 
                      :jornais_sergipes_other,
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
=end
end
