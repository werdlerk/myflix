Myflix::Application.routes.draw do
  root 'videos#index'

  resources :videos, only: [:index, :show] do
    collection do
      get 'search'
    end

  end
  resources :categories, only: [:show]
  
  get 'home' => 'videos#index'
  
  # Mockups
  get 'ui(/:action)', controller: 'ui'
end
