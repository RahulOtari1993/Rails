Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'registrations', sessions: 'sessions'
  }
  # Nested Routes
  devise_scope :user do 
    resources :sports do 
      resources :posts
      resources :announcements
    end
    resources :achievements
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
