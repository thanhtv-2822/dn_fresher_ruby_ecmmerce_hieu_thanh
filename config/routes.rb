Rails.application.routes.draw do
  get "static_pages/home", to: "static_pages#home"
  resources :orders
  resources :users
  resources :addresses
end
