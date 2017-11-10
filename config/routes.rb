Rails.application.routes.draw do

  post   'users/login'
  post   'users/create'
  post   'cards/create'
  get    'cards/pay'
  delete 'cards', to: 'cards#destroy'
  get    'user_wallets/show'
  get    'user_wallets/show_cards'
  get    'user_wallets/set_custom_limit'
  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
