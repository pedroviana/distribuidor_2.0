class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
#  layout ''
  
  def user_for_paper_trail
    current_admin_user
  end
end
