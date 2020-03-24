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
    resources :campaigns
    resources :users
  end

  ## Root Route
  root to: "welcome#index"
end
