Rails.application.routes.draw do

  post 'user/login'
  post 'user/create'
  post 'card/create'
  get  'user_wallet/show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
