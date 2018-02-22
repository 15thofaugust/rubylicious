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
      get :sent_requests, :receive_requests
    end
  end

  resources :versions, only: [:index]
  resources :posts
  resources :password_resets
  resources :relationships, only: [:create, :destroy]
  resources :follow_requests, except: [:show, :new, :edit] do
    collection do
      patch "accept/:id", to: "follow_requests#accept", as: "accept"
      put "accept/:id", to: "follow_requests#accept"
      patch "decline/:id", to: "follow_requests#decline", as: "decline"
      put "decline/:id", to: "follow_requests#decline"
    end
  end
  resources :likes, only: [:create, :destroy]
  resources :comments, except: [:index]
  resources :admins
  patch "/ban/:id", to: "admins#ban", as: "ban"
  patch "/unban/:id", to: "admins#unban", as: "unban"
  patch "/promote/:id", to: "admins#promote", as: "promote"
  patch "/disrank/:id", to: "admins#disrank", as: "disrank"
  get "auth/:provider/callback", to: "sessions#create"
  get "auth/failure", to: "sessions#failure"
  resources :users
  resources :password_resets, except: [:show, :index, :destroy]
  resources :posts
  get "auth/:provider/callback", to: "sessions#create"
  get "auth/failure", to: "sessions#failure"
  get "/notification", to: "notifications#index"
end
