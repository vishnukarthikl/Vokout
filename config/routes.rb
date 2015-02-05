Rails.application.routes.draw do

  root             'application#root'
  get 'home'    => 'static#home'
  get 'help'    => 'static#help'
  get 'about'   => 'static#about'
  get 'contact' => 'static#contact'
  
  get 'sessions/new'
  get 'signup' => 'owners#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  resources :owners do
    member do
      get 'dashboard' => 'owners#dashboard', as: 'dashboard'
    end
    resources :facilities
  end
end
