Rails.application.routes.draw do
  devise_for :users
  resources :sports do 
    resources :posts
    resources :announcements
  end
  resources :achievements
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
