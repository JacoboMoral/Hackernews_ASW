Rails.application.routes.draw do
  get 'newest' => 'contributions#newest'
  
  resources :users
  resources :contributions, path: '/'
  root 'contributions#newest'
end
