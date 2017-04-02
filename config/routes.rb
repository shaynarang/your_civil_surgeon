Rails.application.routes.draw do
  root 'admin/patients#index'

  devise_for :admins, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :appointments, only: [:index, :update], defaults: { format: 'json' } do
    get 'cancel', :on => :member
  end
end
