Myflix::Application.routes.draw do
  root 'pages#front'

  get 'register', to: 'users#new'
  post 'register', to: 'users#create'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  resources :videos, only: [:index, :show] do
    collection do
      get 'search'
    end

  end
  resources :categories, only: [:show]
  

  # Mockups
  get 'ui(/:action)', controller: 'ui'
end
