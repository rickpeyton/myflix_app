Myflix::Application.routes.draw do
  root to: "pages#front"
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  get "/register", to: "users#new"
  resources :users, only: [:create] do
    get "queue", on: :member
  end
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
