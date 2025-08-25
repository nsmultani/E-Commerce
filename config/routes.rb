Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  resources :products, only: [:index, :show]
  
  get 'cart', to: 'shopping_cart#show'
  post 'cart/add/:product_id', to: 'shopping_cart#add_item', as: 'cart_add'
  patch 'cart/update/:product_id', to: 'shopping_cart#update_item', as: 'cart_update'
  delete 'cart/remove/:product_id', to:'shopping_cart#remove_item', as: 'cart_remove'
  delete 'cart/clear', to: 'shopping_cart#clear', as: 'cart_clear'
  
  get 'checkout', to: 'checkouts#new', as: 'checkout'
  post 'checkout', to: 'checkouts#create'
  get 'checkout/success/:id', to: 'checkouts#success', as: 'checkout_success'
  
  resources :orders, only: [:index, :show]
  resources :addresses
  
  resources :categories, only: [:index, :show], param: :slug
  
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  
  root "products#index"
end