Rails.application.routes.draw do

  ## Routes for Admin Users
  constraints(Constraints::SubdomainNotRequired) do
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
  end

  constraints(Constraints::SubdomainRequired) do
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

    resources :campaigns, only: [:show] do
      scope :module => 'campaigns' do
        get '/dashboard', to: 'dashboard#index', as: 'dashboard'
      end
    end

    ## Root Route
    root to: "welcome#index"
  end
end
