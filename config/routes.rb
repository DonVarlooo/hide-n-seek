Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users, only: :show

  resources :games, only: %i[index new create show] do
    member do
      patch :join
      patch :start
      patch :scan
    end

    resources :messages, only: %i[create]
    resources :user_games, only: %i[create]
  end

  resources :user_games, only: :update

  resources :pages, only: [:index]
end
