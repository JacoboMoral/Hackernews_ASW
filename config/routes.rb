Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'logout', to: 'sessions#destroy'
  get 'users' => 'users#edit'
  get 'threads/:id' => 'comments#threads'

  get 'newest' => 'contributions#newest'
  get 'ask' => 'contributions#ask'
  get 'submit' => 'contributions#new'
  get 'comments/:id/' => 'comments#newReply'

  resources :replies, only: :create
  resources :comments, only: :create
  resources :users
  resources :contributions, path: '/'
  root 'contributions#newest'
end
