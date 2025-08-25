# config/routes.rb - Fix the shopping cart routes:

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  # Product routes
  resources :products, only: [:index, :show] do
    collection do
      get :search
    end
  end
  
  # Shopping cart routes - Fixed naming
  get '/cart', to: 'shopping_cart#show', as: 'shopping_cart'
  post '/cart/add', to: 'shopping_cart#add_item', as: 'add_to_cart'
  patch '/cart/update', to: 'shopping_cart#update_item', as: 'update_cart_item'
  delete '/cart/remove', to: 'shopping_cart#remove_item', as: 'remove_cart_item'
  delete '/cart/clear', to: 'shopping_cart#clear', as: 'clear_cart'
  
  # Category routes for navigation
  resources :categories, only: [:index, :show], param: :slug do
    resources :products, only: [:index], controller: 'category_products'
  end
  
  # Static pages routes
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  
  # Set products as the homepage
  root "products#index"
end