Rails.application.routes.draw do
  get 'hashtags/new'
  get 'hashtags/create'
  resources :posts do
    resources :hashtags, module: :posts
  end
  resources :achievements
  resources :sports do  
    resources :posts do 
      resources :comments
        # resources :hashtags, module: :comments
    end  
    resources :players
    resources :sportannouncements  
  end  
  root 'pages#home'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
