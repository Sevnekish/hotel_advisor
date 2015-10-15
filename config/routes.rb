Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show]
  
  resources :hotels do
    resources :reviews, except: [:show, :index]
  end

  root 'static_pages#home'
end
