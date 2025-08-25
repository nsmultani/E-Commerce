# config/routes.rb - Simple working routes:

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  # Product routes
  resources :products, only: [:index, :show]
  
  # Simple shopping cart routes
  get 'cart', to: 'shopping_cart#show'
  post 'cart/add/:product_id', to: 'shopping_cart#add_item', as: 'cart_add'
  patch 'cart/update/:product_id', to: 'shopping_cart#update_item', as: 'cart_update'
  delete 'cart/remove/:product_id', to: 'shopping_cart#remove_item', as: 'cart_remove'
  delete 'cart/clear', to: 'shopping_cart#clear', as: 'cart_clear'
  
  # Checkout routes
  get 'checkout', to: 'checkouts#new', as: 'checkout'
  post 'checkout', to: 'checkouts#create'
  get 'checkout/success/:id', to: 'checkouts#success', as: 'checkout_success'

  # Category routes
  resources :categories, only: [:index, :show], param: :slug
  
  # Static pages routes
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  
  root "products#index"
end