Myflix::Application.routes.draw do
  root 'videos#index'

  get 'ui(/:action)', controller: 'ui'

  get 'home' => 'videos#index'
end
