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
  get 'dashboard-history' => 'dashboard#history', as: 'dashboard_history'

  get 'contact' => 'contact_messages#new', as: 'contact'
  post 'contact' => 'contact_messages#create', as: 'post_contact'

  get 'owners/edit' => 'owners#edit', as: 'edit_owner'
  get 'profile' => 'owners#show', as: 'current_owner'
  get 'owners/:code/confirm' => 'owners#confirm', as: 'confirm_owner'
  get 'owners/unconfirmed' => 'owners#unconfirmed', as: 'unconfirmed_owner'

  post 'owners/:id/deactivate' => 'admins#deactivate', as: 'deactivate_owner'
  post 'owners/:id/activate' => 'admins#activate', as: 'activate_owner'
  delete 'owners/:id/destroy' => 'admins#destroy', as: 'delete_owner'
  get 'deactivated' => 'owners#deactivated', as: 'deactivated_owner'
  get 'owners/:id/edit' => 'admins#edit', as: 'edit_owner_admin'
  patch 'owners/:id/update' => 'admins#update', as: 'update_owner_admin'

  get 'new-collaborator' => 'owners#new_collaborator', as:'new_collaborator'
  post 'new-collaborator' => 'owners#create_collaborator', as:'create_collaborator'
  get 'collaborators/:code/confirm' => 'owners#confirm_collaborator', as: 'confirm_collaborator'
  patch 'collaborator-password/:id' => 'owners#collaborator_password', as: 'collaborator_password'

  resources :owners do
    resources :facilities
  end

  resources :facilities do
    resources :memberships
    resources :members
    resources :audit_logs, only:[:index]
  end

  get 'admin-dashboard' => 'admins#dashboard', as: 'admin_dashboard'
end
