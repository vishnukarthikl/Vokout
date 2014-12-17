Rails.application.routes.draw do
  get 'signup'  => 'owners#new'
  get 'signin' => 'owners#signin'
  resources :owners
end
