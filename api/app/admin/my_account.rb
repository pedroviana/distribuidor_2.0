ActiveAdmin.register AdminUserFake, as: 'Minha Conta' do
  actions :edit, :update

  controller do
    def redirect_to_edit
      redirect_to edit_admin_minha_contum_path(current_admin_user), :flash => flash and return
    end
     
    def update
      if current_admin_user.update_attributes(params[:minha_conta].permit(:name, :password, :password_confirmation))
        sign_in current_admin_user, :bypass => true
        redirect_to admin_minha_conta_path, notice: "Senha atualizada com sucesso!" and return
      else
        message = []
        current_admin_user.errors.messages.each do |key, value|
          message << I18n.t("activerecord.attributes.admin_user.#{key}") + " #{value.first}"
        end
        
        redirect_to edit_admin_minha_contum_path(current_admin_user), :alert => message.first and return
      end
    end
      
    alias_method :index, :redirect_to_edit
    alias_method :show,  :redirect_to_edit
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :password
      f.input :password_confirmation
    end

    f.actions
  end
end