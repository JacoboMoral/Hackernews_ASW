Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'logout', to: 'sessions#destroy'

  get 'newest' => 'contributions#newest'
  get 'submit' => 'contributions#new'

  resources :reply
  resources :comment, except: [:index, :edit]
  resources :users
  resources :contributions, path: '/'
  root 'contributions#newest'
end
