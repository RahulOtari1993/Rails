Rails.application.routes.draw do
  require 'constraints/subdomain_not_required'
  require 'constraints/subdomain_required'

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
        omniauth_callbacks: "participants/omniauth_callbacks"
    }

    devise_scope :participant do
      get "participants/auth/facebook/setup" => "participants/omniauth_callbacks#setup"
      get "participants/auth/google_oauth2/setup" => "participants/omniauth_callbacks#google_oauth2_setup"
      get "participants/auth/twitter/setup" => "participants/omniauth_callbacks#twitter_oauth2_setup"
    end

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

          ## Campaign Config Routes
          resources :configs, only: [:edit, :update], :controller => "campaign_configs"

          ## Rewards Routes
          resources :rewards do
            collection do
              get '/generate_reward_json', to: 'rewards#generate_reward_json', as: :generate_reward_json
            end
            get '/download_csv_popup', to: 'rewards#download_csv_popup', as: :download_csv_popup
            post '/reward_export', to: 'rewards#reward_export', as: :reward_export
            get '/coupon_form', to: 'rewards#coupon_form', as: :coupon_form
            post '/create_coupon', to: 'rewards#create_coupon', as: :create_coupon
            member do
              get :participant_selection_form, as: :participant_selection_form
              post :participant_selection, as: :participant_selection
            end
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
              delete '/remove_tag', to: 'challenges#remove_tag'
              post '/add_tag', to: 'challenges#add_tag'
              get :get_insight_for_line_chart
            end
          end

          ## Profile Attributes Routes
          resources :profile_attributes

          ## Network Routes
          resources :networks do
            collection do
              get :connect_facebook
              get '/auth/facebook/callback', to: 'networks#facebook_callback'
            end
          end

          ## Participants Routes
          resources :users, controller: "participants", only: [:index, :show] do
            collection do
              get '/fetch_participants', to: 'participants#fetch_participants'
              get '/participants', to: 'participants#participants'
              get '/get_data_for_chart_graph', to: 'participants#get_data_for_chart_graph'
            end
            member do
              get '/users', to: 'participants#users'
              post '/participants', to: 'participants#export_participants'
              delete '/remove_tag', to: 'participants#remove_tag'
              post '/add_tag', to: 'participants#add_tag'
              post '/add_note', to: 'participants#add_note'
              put '/update_status', to: 'participants#update_status'
              get :activities_list, to: 'participants#activities_list'
              get :rewards_list, to: 'participants#rewards_list'
              get :notes_list, to: 'participants#notes_list'
            end
          end
        end
        post '/delete_reward_filter/:id', to: 'rewards#delete_reward_filter', as: :delete_reward_filter
      end
    end

    # routes for end user participants challenge submission
    namespace :participants do
      resources :challenges, only: [] do
        member do
          get :details
          post :submission
          post :quiz_submission
        end
      end
      resources :rewards, only: [] do
        member do
          get :details
          post :claim
        end
      end
      resources :accounts, only: [], :controller => "participant_accounts" do
        collection do
          get :details_form
          put :update_profile_details
          put :disconnect
          get :fetch_activities
        end
      end
    end

    ## Root Route
    root to: 'welcome#index'
    get '/template', to: 'welcome#home', as: :template
    get '/participants', to: 'welcome#participants', as: :participants
    get '/welcome', to: 'welcome#welcome'

    ## API Routes
    namespace :api, defaults: {format: 'json'} do
      namespace :v1, defaults: {format: 'json'} do
        mount_devise_token_auth_for 'Participant', at: 'participants', controllers: {
            registrations: 'api/v1/override/registrations',
            sessions: 'api/v1/override/sessions'
        }

        devise_scope :participant do
          ## Rewards API Routes
          resources :rewards, only: [:index, :show]

          ## Challenges API Routes
          resources :challenges, only: [:index, :show]

          ## Participant Account Routes
          resources :participant_account, only: [] do
            collection do
              get :show
              put :update
              post :facebook
              post :twitter
              post :disconnect
              get :email_settings, to: 'participant_account#fetch_email_settings'
              post :email_settings, to: 'participant_account#update_email_settings'
            end
          end
        end
      end
    end
  end
end
