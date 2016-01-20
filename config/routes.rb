require 'sidekiq/web'

Myflix::Application.routes.draw do
  root 'pages#front'

  get 'home', to: 'videos#index'

  get 'register', to: 'users#new'
  get 'register/:token', to: 'users#new_with_invitation', as: 'register_with_invitation'
  post 'register', to: 'users#create'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
  get 'forgot_password', to: 'passwords#new'
  post 'forgot_password', to: 'passwords#create'
  get 'reset_password', to: 'passwords#edit'
  put 'reset_password', to: 'passwords#update'
  get 'invalid_token', to: 'pages#invalid_token'

  resources :users, only: [:show]

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

  resources :relationships, only: [:create, :destroy]

  resources :invitations, only: [:new, :create]

  get 'my_queue', to: 'queue_items#index'
  get 'people', to: 'relationships#index'

  # Mockups
  get 'ui(/:action)', controller: 'ui'

  mount Sidekiq::Web => '/sidekiq'
end
