Rails.application.routes.draw do
  get 'newest' => 'contributions#newest'
  get 'submit' => 'contributions#new'
  
  resources :users
  resources :contributions, path: '/'
  root 'contributions#newest'
end
