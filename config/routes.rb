Rails.application.routes.draw do
  get "static_pages/home", to: "static_pages#home"
  resources :orders
  resources :users do
    resource :upload, only: [:update]
    resource :order, only: [:show], to: "orders#index"
  end
  resources :addresses
end
