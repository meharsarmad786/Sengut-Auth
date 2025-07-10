Rails.application.routes.draw do
  devise_for :users
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'home#index'
  
  get 'dashboard', to: 'home#dashboard'
  
  resources :organizations do
    member do
      post 'join'
      delete 'leave'
      get 'analytics'
    end
  end
  
  resources :parental_consents, except: [:index]
  
  # Custom route for parental consent management
  get 'my_parental_consent', to: 'parental_consents#show_or_new', as: 'my_parental_consent'
  
  resources :age_groups, only: [:index, :show]
  
  # Admin routes
  namespace :admin do
    resources :organizations do
      resources :organization_memberships, only: [:index, :show, :edit, :update, :destroy]
    end
    resources :users, only: [:index, :show, :edit, :update, :destroy]
    resources :participation_activities, only: [:index, :show, :destroy]
    root 'dashboard#index'
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
