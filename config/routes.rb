Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/home", to: "static_pages#home"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    delete "/logout", to: "sessions#destroy"
    resources :products, only: :show
    resources :orders, only: :create
    resources :carts, only: :index do
      collection do
        get "/add_item_to_cart/:id", to: "carts#add_item_to_cart", as: "add_item_to"
        delete "/remove_item_in_cart/:id", to: "carts#remove_item_in_cart", as: "remove_item_in"
        put "update_cart/:id", to: "carts#update_cart", as: "update_item"
      end
    end
    namespace :admin do
      root "static_pages#home"
      get "/home", to: "static_pages#home"
      resources :products
    end
  end
end
