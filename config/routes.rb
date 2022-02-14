Rails.application.routes.draw do
  resources :sportannouncements
  get 'hashtags/new'
  get 'hashtags/create'
  resources :posts do
    resources :hashtags, module: :posts
  end
  resources :comments do
    resources :hashtags, module: :comments
  end
  resources :achievements
  resources :sports
  resources :players
  root 'pages#home'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
