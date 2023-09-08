Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users, only: %i[index show]

  resources :games, only: %i[index new create show] do
    member do
      patch :join
      patch :start
      patch :scan
      get :rematch
    end

    resources :messages, only: %i[create]
    resources :user_games, only: %i[create]
  end

  resources :user_games, only: %i[update]

  resources :pages, only: [:index] do
    member do
      get :thanks
    end
  end
end
