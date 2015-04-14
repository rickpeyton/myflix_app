Myflix::Application.routes.draw do
  root to: "pages#front"
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  get "/register", to: "users#new"
  get "my-queue", to: "queue_items#index"
  get "people", to: "relationships#index"
  post "update-my-queue", to: "queue_items#update_my_queue"
  resources :queue_items, only: [:create, :destroy]
  resources :users, only: [:show, :create]
  resources :videos, only: [:show] do
    resources :reviews, only: [:create]
    collection do
      get '/search', to: 'videos#search'
    end
  end
  resources :categories, only: [:show]
  resources :relationships, only: [:create, :destroy]
  get "/sign-in", to: "sessions#new"
  post "/sign-in", to: "sessions#create"
  get "/sign-out", to: "sessions#destroy"
  get "/forgot-password", to: "passwords#new"
  get "/invalid-token", to: "passwords#invalid"
  resources :passwords, only: [:show, :create, :update]
  get "/invite", to: "invitations#new"
end
