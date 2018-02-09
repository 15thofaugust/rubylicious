Rails.application.routes.draw do
  mount ActionCable.server => "/cable"

  root "posts#index"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/signup", to: "users#new"
  post "/signup",  to: "users#create"
  get "/finish", to: "users#finish"
  post "/finish", to: "users#finish"
  get "/comment", to: "comments#index"
  get "/posts/hashtag/:name", to: "posts#hashtags"
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :posts
  resources :password_resets
  resources :relationships, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]
  resources :comments, except: [:index]

  get "auth/:provider/callback", to: "sessions#create"
  get "auth/failure", to: "sessions#failure"
  resources :users
  resources :password_resets, except: [:show, :index, :destroy]
  resources :posts
  get "auth/:provider/callback", to: "sessions#create"
  get "auth/failure", to: "sessions#failure"
  get "/notification", to: "notifications#index"

end
