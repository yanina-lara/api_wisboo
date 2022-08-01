Rails.application.routes.draw do
  post '/products', action: :index, controller: 'products'
end
