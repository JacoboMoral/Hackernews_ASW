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
  get 'replies/:id/vote' => 'replies#vote'
  get 'replies/:id/unvote' => 'replies#unvote'

  get 'contributions' => 'contributions#index'
  get 'contributions/:id' => 'contributions#show'


  post 'contributions/vote/:id' => 'contributions#vote'
  post 'contributions/unvote/:id' => 'contributions#unvote'
  post 'comments/vote/:id' => 'comments#vote'
  post 'comments/unvote/:id' => 'comments#unvote'

  get 'contributions/vote/:id' => 'contributions#vote'
  get 'contributions/unvote/:id' => 'contributions#unvote'
  get 'comments/vote/:id' => 'comments#vote'
  get 'comments/unvote/:id' => 'comments#unvote'



  resources :reply
  resources :comments, only: :create
  resources :users
  resources :contributions, path: '/'
  root 'contributions#newest'

end
