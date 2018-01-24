Rails.application.routes.draw do
  root "sessions#new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/signup", to: "users#new"
  post "/signup",  to: "users#create"
  get "/finish", to: "users#finish"
  post "/finish", to: "users#finish"
  resources :users
  resources :password_resets, only: [:new, :create, :edit, :update]
  get "auth/:provider/callback", :to => "sessions#create"
  get "auth/failure", :to => "sessions#failure"
end
