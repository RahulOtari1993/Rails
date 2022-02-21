Rails.application.routes.draw do
  devise_for :users
  resources :sports
  resources :posts
  resources :achievements
  resources :announcements
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
