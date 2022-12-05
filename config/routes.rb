Rails.application.routes.draw do
  resources :items
  get "/items/" => "items#show"
  # get '/list'  , to: 'items#index' 
  get "/items/download/:id" => "items#download"
  # get '/remove'  , to: 'items#remove_file'
  resources :items, only: [:index,:name, :show, :create, :update, :destroy,:download]
  # resources :items
  # post 'authenticate', to: 'authentication#authenticate'
end
