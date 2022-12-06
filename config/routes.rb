Rails.application.routes.draw do
  # get '/destroy' => 'items#destroy' 
  # resources :items
  # get "/items/" => "items#create"
  
  # get "/items/download/:id" => "items#download"
  get '/remove'  , to: 'items#destroy'
  resources :items, only: [:index,:name, :show, :create, :update, :download]
  # resources :items
  
end
