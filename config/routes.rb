Rails.application.routes.draw do
  resources :homepages, only: [ :index ]
  resources :users, only: [ :show, :edit, :update ] do
    member do
      post :edit_bio
      patch :update_bio
    end
  end
  resource :session
  resource :registers, only: [ :new, :create ]
  resources :posts, only: [ :show, :create, :edit, :update, :destroy ] do
    resources :comments, only: [ :index, :create, :update, :destroy ]
    member do
      post :like
      delete :unlike
    end
  end
  resources :passwords, param: :token
  # get "homepages/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Omniauth routes
  get "auth/:provider/callback", to: "sessions#create"
  get "/login", to: "sessions#new"

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "landing#index"
end
