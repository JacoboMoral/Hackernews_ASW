Rails.application.routes.draw do
  resources :contributions
  resources :users
    root 'application#main'
end
