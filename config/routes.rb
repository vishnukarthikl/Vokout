Rails.application.routes.draw do
  get 'sessions/new'

  get 'signup' => 'owners#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  resources :owners
end
