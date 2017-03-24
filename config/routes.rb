Rails.application.routes.draw do
  devise_for :admins, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :appointments, only: [:index], defaults: { format: 'json' }
end
