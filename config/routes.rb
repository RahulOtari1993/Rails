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

    devise_for :participants, controllers: {
      registrations: 'participants/registrations',
      sessions: 'participants/sessions',
      passwords: 'participants/passwords',
      confirmations: 'participants/confirmations',
      :omniauth_callbacks => "participants/omniauth_callbacks"
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
          resources :template, only: [:edit, :update]

          ## Rewards Routes
          resources :rewards do 
            collection do
              get '/generate_reward_json', to: 'rewards#generate_reward_json', as: :generate_reward_json
            end
            get '/ajax_user', to: 'rewards#ajax_user', as: :ajax_user
            post '/reward_export', to: 'rewards#reward_export', as: :reward_export
            get '/ajax_coupon_form', to: 'rewards#ajax_coupon_form', as: :ajax_coupon_form
            post '/create_coupon', to: 'rewards#create_coupon', as: :create_coupon
          end

          ## Challenge Routes
          resources :challenges
        end
        post '/delete_reward_filter/:id', to: 'rewards#delete_reward_filter', as: :delete_reward_filter
      end
    end

    ## Root Route
    root to: "welcome#home"
    get '/participants', to: 'welcome#participants', as: :participants
  end
end
