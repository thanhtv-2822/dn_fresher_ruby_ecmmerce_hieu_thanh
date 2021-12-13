Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
  end
  get "static_pages/home", to: "static_pages#home"
end
