Myflix::Application.routes.draw do
  root 'pages#front'

  get 'home', to: 'videos#index'

  get 'register', to: 'users#new'
  post 'register', to: 'users#create'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  resources :videos, only: [:index, :show] do
    collection do
      get 'search'
    end
    resources :reviews, only: [:create]
  end
  resources :categories, only: [:show]

  resources :queue_items, only: [:index, :destroy, :create] do
    collection do
      post :change
    end
  end

  get 'my_queue', to:'queue_items#index'

  # Mockups
  get 'ui(/:action)', controller: 'ui'
end
