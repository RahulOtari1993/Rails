Rails.application.routes.draw do

  ## Routes for Admin Users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  ## Routes for Users
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
  }

  namespace :organizations do
    devise_for :users, controllers: {
      registrations: 'organizations/invitations',
    }

    resources :users, only: [:index] do
      member do
        patch :toggle_active_status
      end
    end
    resources :campaigns, only: [:index, :new, :create] do
      member do
        patch :deactivate
      end
    end
  end

  ## Root Route
  root to: "welcome#index"
end
