# config/routes.rb - Add search route:

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  # Product routes
  resources :products, only: [:index, :show] do
    collection do
      get :search
    end
  end
  
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