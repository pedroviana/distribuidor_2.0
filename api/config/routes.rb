Api::Application.routes.draw do
  root to: "admin/dashboard#index"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get "qr/index"
  
#  get "user_events/show"
#  get "user_events/invalid_token"
#  post "user_events/update"
  
  resources :user_event_confirmations do
    collection do
      get 'invalid_token'
      get 'already_confirmed'
      get 'thanks'
    end
  end
end