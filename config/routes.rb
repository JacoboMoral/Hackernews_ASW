Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'logout', to: 'sessions#destroy'
  get 'users' => 'users#edit'
  get 'threads/:id' => 'comments#threads'

  get 'newest' => 'contributions#newest'
  get 'ask' => 'contributions#ask'
  get 'submit' => 'contributions#new'
  get 'comments/:id' => 'comments#newReply'
  
  get 'contributions/:id/vote' => 'contributions#vote'
  get 'contributions/:id/unvote' => 'contributions#unvote'
  get 'comments/:id/vote' => 'comments#vote'
  get 'comments/:id/unvote' => 'comments#unvote'

  resources :replies
  resources :comments, only: :create
  resources :users
  resources :contributions, path: '/' 
  root 'contributions#newest'
end
