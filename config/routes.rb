Rails.application.routes.draw do
  devise_for :users
  
  # Admin namespace
  namespace :admin do
    root 'dashboard#index'
    resources :users
    resources :employees
    resources :departments
    resources :positions
    
    # Segmentation routes
    get 'segmentation', to: 'segmentation#index'
    
    # Rutas para segmentaciones
    post 'segmentation/segmentations', to: 'segmentation#create_segmentation'
    patch 'segmentation/segmentations/:id', to: 'segmentation#update_segmentation', as: 'update_segmentation'
    delete 'segmentation/segmentations/:id', to: 'segmentation#destroy_segmentation', as: 'destroy_segmentation'
    
    # Rutas para items de segmentación
    post 'segmentation/:segmentation_id/items', to: 'segmentation#create_item', as: 'create_segmentation_item'
    patch 'segmentation/items/:id', to: 'segmentation#update_item', as: 'update_segmentation_item'
    delete 'segmentation/items/:id', to: 'segmentation#destroy_item', as: 'destroy_segmentation_item'
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "admin/dashboard#index"
end
