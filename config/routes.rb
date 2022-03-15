Rails.application.routes.draw do
  # get 'default/dashboard'
  root 'default#dashboard'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  ## Business Routes
  resources :businesses
  get 'fetch_businesses', to: 'businesses#fetch_businesses'

  # Offers routes
  resources :offers
  get 'fetch_offers', to: 'offers#fetch_offers'
end
