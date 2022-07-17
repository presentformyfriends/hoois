Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # resources :lookups

  root to: "public#index", as: "homepage"

  get 'lookup', action: :show, controller: 'lookup'
  
end
