Rails.application.routes.draw do
  namespace :admin do
      resources :prompts
      resources :requests
      resources :transactions
      resources :users
      resources :wallets

      root to: "prompts#index"
    end
  devise_for :users
  root to: "pages#home"
  get "/refund", to: "pages#refund"
  get "/cookies", to: "pages#cookies"
  get "/terms", to: "pages#terms"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :prompts, only: [:index, :show, :new, :create, :destroy] do
    resources :requests, only: [:create, :new]
  end
  resources :requests, only: [:index, :show]
  get "/checkout", to: "checkouts#show"
  get "/billing", to: "billing#show"
  get "requests/:id/remove_bg", to: "requests#remove_bg", as: :remove_bg
  get "requests/:id/download", to: "requests#download", as: :download
  get "/history", to: "requests#history", as: :history
end
