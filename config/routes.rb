Rails.application.routes.draw do

  resources :members

  root 'application#root'
  get 'home' => 'static#home'
  get 'help' => 'static#help'
  get 'about' => 'static#about'
  get 'contact' => 'static#contact'

  get 'sessions/new'
  get 'signup' => 'owners#new'
  get 'login' => 'sessions#new', as: 'login'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  get 'setup' => 'accountsetup#setup', as: 'setup'
  get 'setupstatus' => 'accountsetup#setup_status', as: 'setup_status'

  get 'dashboard' => 'dashboard#main', as: 'dashboard'
  get 'dashboard-members' => 'dashboard#members', as: 'dashboard_members'

  resources :owners do
    resources :facilities
  end

  resources :facilities do
    resources :memberships
    resources :members
  end
end
