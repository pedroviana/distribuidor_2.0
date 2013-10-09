Api32::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: "admin/dashboard#index"
  get "qr/index"

  resources :user_event_confirmations do
    collection do
      get 'invalid_token'
      get 'already_confirmed'
      get 'confirmations_closed'
      get 'thanks'
    end
  end
end