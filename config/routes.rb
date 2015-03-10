Myflix::Application.routes.draw do
  root 'videos#index'

  resources :videos, only: [:index, :show]
  get 'home' => 'videos#index'
  
  # Mockups
  get 'ui(/:action)', controller: 'ui'
end
