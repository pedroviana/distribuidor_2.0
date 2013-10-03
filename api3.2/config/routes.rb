Api32::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: "admin/dashboard#index"
  get "qr/index"
  
#  get "user_events/show"
#  get "user_events/invalid_token"
#  post "user_events/update"

  resources :user_event_confirmations do
    collection do
      get 'invalid_token'
      get 'already_confirmed'
      get 'confirmations_closed'
      get 'thanks'
    end
  end
end