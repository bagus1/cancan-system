Rails.application.routes.draw do
  devise_for :users
  
  # Main application routes
  resources :orders
  
  # Admin interface for managing roles and permissions
  namespace :admin do
    resources :roles do
      member do
        get :permissions
      end
    end
    resources :users, only: [:index, :show, :edit, :update] do
      member do
        get :roles
      end
    end
    resources :ability_permissions, path: 'ability-permissions'
    resources :user_roles, only: [:index, :create, :destroy]
    resources :role_abilities, only: [:index, :create, :destroy]
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "orders#index"
end
