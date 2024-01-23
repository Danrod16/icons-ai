Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :prompts, only: [:index, :show, :new, :create, :destroy] do
    resources :requests, only: [:create, :new]
  end
  resources :requests, only: [:index, :show]
  get "requests/:id/remove_bg", to: "requests#remove_bg", as: :remove_bg
  get "requests/:id/download", to: "requests#download", as: :download
  get "history", to: "requests#history", as: :history
end
