Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  # Product routes
  resources :products, only: [:index, :show]
  
  # Static pages routes
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  
  # Set products as the homepage
  root "products#index"
end