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
            get '/download_csv_popup', to: 'rewards#download_csv_popup', as: :download_csv_popup
            post '/reward_export', to: 'rewards#reward_export', as: :reward_export
            get '/coupon_form', to: 'rewards#coupon_form', as: :coupon_form
            post '/create_coupon', to: 'rewards#create_coupon', as: :create_coupon
          end

          ## Challenge Routes
          resources :challenges do
            collection do
              get '/fetch_challenges', to: 'challenges#fetch_challenges'
            end
            member do
              get '/participants', to: 'challenges#participants'
              post '/export_participants', to: 'challenges#export_participants'
              get '/duplicate', to: 'challenges#duplicate'
              get '/toggle', to: 'challenges#toggle'
              post '/remove_tag', to: 'challenges#remove_tag'
              post '/add_tag', to: 'challenges#add_tag'
            end
          end
        end
        post '/delete_reward_filter/:id', to: 'rewards#delete_reward_filter', as: :delete_reward_filter
      end
    end

    ## Root Route
    root to: "welcome#index"
    get '/template', to: 'welcome#home', as: :template
    get '/participants', to: 'welcome#participants', as: :participants
  end
end
