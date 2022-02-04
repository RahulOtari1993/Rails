Rails.application.routes.draw do
  get 'selectdrop/index'
  get 'validation/index'
  root 'validation#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
