Rails.application.routes.draw do
  
  get 'favicon/webmanifest' => 'favicon#webmanifest', format: :json
  get 'favicon/browserconfig' => 'favicon#browserconfig', format: :xml

  root to: "public#index", as: "homepage"
  
  get '/lookup', action: :create, controller: 'lookup'

end
