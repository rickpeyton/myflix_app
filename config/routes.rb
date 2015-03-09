Myflix::Application.routes.draw do
  root to: "users#front"
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  get "/register", to: "users#new"
  resources :users, only: [:create]
  resources :videos, only: [:show] do
    collection do
      get '/search', to: 'videos#search'
    end
  end
  resources :categories, only: [:show]
  get "/sign-in", to: "sessions#new"
  post "/sign-in", to: "sessions#create"
  get "/log-out", to: "sessions#destroy"
end
