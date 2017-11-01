Rails.application.routes.draw do

  get 'user/index'
  post 'user/login'
  post 'user/create'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
