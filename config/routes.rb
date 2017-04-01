Rails.application.routes.draw do
  devise_for :admins, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :appointments, only: [:index, :update], defaults: { format: 'json' } do
    get 'cancel', :on => :member
  end
end
