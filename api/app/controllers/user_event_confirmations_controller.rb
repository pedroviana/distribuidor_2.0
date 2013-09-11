class UserEventConfirmationsController < ApplicationController
  def invalid_token

  end

  def update
    raise params.inspect
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
#    def permitted_params
#      params.permit(:admin_user_type => [:title, :area_ids => []])
#    end
end
