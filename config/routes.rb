Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :requests, only: [:create, :show, :index]
  get "requests/:id/remove_bg", to: "requests#remove_bg", as: :remove_bg
  get "requests/:id/download", to: "requests#download", as: :download
  get "history", to: "requests#history", as: :history
end
