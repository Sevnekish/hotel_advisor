Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show]
  
  resources :hotels do
    resources :reviews
  end

  root 'static_pages#home'
end
