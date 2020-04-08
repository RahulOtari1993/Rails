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

    namespace :admin do
      namespace :organizations do
        devise_for :users, controllers: {
          registrations: 'admin/organizations/invitations',
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

      scope :module => 'campaigns' do
        resources :campaigns, only: [:show, :edit, :update] do
          get '/dashboard', to: 'dashboard#index', as: 'dashboard'

          ## Template Routes
          resources :template, only: [:index, :update]
        end
      end
    end

    ## Root Route
    root to: "welcome#index"
  end
end
