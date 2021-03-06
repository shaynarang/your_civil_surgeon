Rails.application.routes.draw do
  root 'home#index'

  devise_for :admins, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :appointments, only: [:index, :update], defaults: { format: 'json' } do
    get 'cancel', :on => :member
  end

  resources :medical_records do
    get 'download', :on => :member
  end
end
