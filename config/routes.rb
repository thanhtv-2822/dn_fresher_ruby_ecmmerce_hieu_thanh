require "sidekiq/web"

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.is_admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  namespace :api do
    namespace :v1 do
      resources :products
    end
  end

  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    devise_for :users
    get "/home", to: "static_pages#home"
    resources :addresses
    resources :contributes, only: %i(new create index)
    resources :orders
    resources :uploads, only: :update
    resources :order, only: :show, to: "orders#show"
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
      resources :products
      resources :categories
      resources :import, only: %i(new create)
      resources :contributes, only: %i(show index update)
      resources :users
      resources :orders do
        resources :order_details, only: [:index]
      end
    end
  end
end
