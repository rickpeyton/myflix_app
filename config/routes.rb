Myflix::Application.routes.draw do
  root to: "pages#front"
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  get "/register", to: "users#new"
  get "my-queue", to: "queue_items#index"
  post "update-my-queue", to: "queue_items#update_my_queue"
  resources :queue_items, only: [:create, :destroy]
  resources :users, only: [:create]
  resources :videos, only: [:show] do
    resources :reviews, only: [:create]
    collection do
      get '/search', to: 'videos#search'
    end
  end
  resources :categories, only: [:show]
  get "/sign-in", to: "sessions#new"
  post "/sign-in", to: "sessions#create"
  get "/sign-out", to: "sessions#destroy"
end
