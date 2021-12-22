Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/home", to: "static_pages#home"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    delete "/logout", to: "sessions#destroy"
    resources :addresses
    resources :contributes, only: [:new, :create]
    resources :orders
    resources :users do
      resource :upload, only: [:update]
      resource :order, only: [:show], to: "orders#show"
      resources :contributes, only: [:show]
    end
    resources :products, only: :show
    resources :carts, only: %i(index destroy) do
      collection do
        post "/add_item_to_cart/:id", to: "carts#create", as: "add_item_to"
        put "/update_cart/:id", to: "carts#update_cart", as: "update_item"
        put "/update_rating/:id", to: "carts#update_rating_item", as: "update_rating_item"
      end
    end
    namespace :admin do
      root "static_pages#home"
      get "/home", to: "static_pages#home"
      delete "/logout", to: "static_pages#destroy"
    end
  end
end
