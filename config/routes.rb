Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'logout', to: 'sessions#destroy'
  put 'users/:id/apiUpdate' => 'users#apiUpdate'
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

  get '/contributions' => 'contributions#index'
  #api
  get 'contributions/:id' => 'contributions#show'
  get '/contributions/:id/comments' => 'comments#contribution_comments'
  get 'users/:user/comments' => 'comments#user_comments'
  get 'user_contributions' => 'contributions#user_contributions'
  get '/comments/:id/replies' => 'replies#comment_replies'

  post 'contributions/vote/:id' => 'contributions#apiVote'
  post 'contributions/unvote/:id' => 'contributions#apiDownVote'
  post 'comments/vote/:id' => 'comments#vote'
  post 'comments/unvote/:id' => 'comments#unvote'

  get 'contributions/vote/:id' => 'contributions#vote'
  get 'contributions/unvote/:id' => 'contributions#unvote'
  get 'comments/vote/:id' => 'comments#vote'
  get 'comments/unvote/:id' => 'comments#unvote'

  post 'contributions' => 'contributions#create'
  post 'contributions/ask' => 'contributions#apiCreateAsk'
  post 'contributions/url' => 'contributions#apiCreateUrl'
  post 'comments/:id/apiCreateComment' => 'comments#apiCreateComment'
  post 'comments/apiUpVote/:id' => 'comments#apiUpVote'
  post 'comments/apiDownVote/:id' => 'comments#apiDownVote'

  resources :replies
  resources :comments
  resources :users
  resources :contributions, path: '/'
  root 'contributions#newest'

end
