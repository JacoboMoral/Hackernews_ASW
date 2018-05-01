Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'logout', to: 'sessions#destroy'
  get 'users' => 'users#edit'
  get 'threads/:id' => 'comments#threads'

  get 'newest' => 'contributions#newest'
  get 'ask' => 'contributions#ask'
  get 'submit' => 'contributions#new'

  post '/vote/:id' => 'contributions#vote'
  post '/unvote/:id' => 'contributions#unvote'
  post '/vote/:id' => 'comments#vote'
  post '/unvote/:id' => 'comments#unvote'

  get '/vote/:id' => 'contributions#vote'
  get '/unvote/:id' => 'contributions#unvote'
  get '/vote/:id' => 'comments#vote'
  get '/unvote/:id' => 'comments#unvote'
  


  resources :reply
  resources :comments, only: :create
  resources :users
  resources :contributions, path: '/' 
  root 'contributions#newest'
end
