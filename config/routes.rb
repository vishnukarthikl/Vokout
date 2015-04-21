Rails.application.routes.draw do

  resources :contact_messages

  resources :members

  root 'application#root'
  get 'home' => 'static#home'
  get 'help' => 'static#help'
  get 'about' => 'static#about'

  get 'sessions/new'
  get 'signup' => 'owners#new'
  get 'login' => 'sessions#new', as: 'login'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  get 'setup' => 'facilities#setup', as: 'setup'

  get 'dashboard' => 'dashboard#overview', as: 'dashboard'
  get 'dashboard-members' => 'dashboard#members', as: 'dashboard_members'

  get 'contact' => 'contact_messages#new', as: 'contact'
  post 'contact' => 'contact_messages#create', as: 'post_contact'

  resources :owners do
    resources :facilities
  end

  resources :facilities do
    resources :memberships
    resources :members
  end
end
