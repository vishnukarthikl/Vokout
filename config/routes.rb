Rails.application.routes.draw do

  resources :password_resets
  resources :contact_messages
  devise_for :admins

  resources :members do
    resources :purchases
  end

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
  get 'dashboard-memberships' => 'dashboard#memberships', as: 'dashboard_memberships'

  get 'contact' => 'contact_messages#new', as: 'contact'
  post 'contact' => 'contact_messages#create', as: 'post_contact'

  resources :owners do
    resources :facilities
  end

  post 'owner/:id/deactivate' => 'owners#deactivate', as: 'deactivate_owner'
  post 'owner/:id/activate' => 'owners#activate', as: 'activate_owner'
  get 'deactivated' => 'owners#deactivated', as: 'deactivated_owner'

  resources :facilities do
    resources :memberships
    resources :members
  end

  get 'admin-dashboard' => 'admins#dashboard', as: 'admin_dashboard'
end
