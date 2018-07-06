  Rails.application.routes.draw do

  # devise url
  devise_for :admins, controllers: {
  sessions:      'admins/sessions',
  passwords:     'admins/passwords',
  registrations: 'admins/registrations'
  }

  devise_for :users, controllers: {
  sessions:      'users/sessions',
  passwords:     'users/passwords',
  registrations: 'users/registrations'
  }

  devise_scope :user do
    get '/logout', to: 'devise/sessions#destroy', as: 'logout'
  end

  # admins url
  get 'admins', to: 'admins#index', as: 'admins'

  get 'admins/:id', to: 'admins#show', as: 'admin'

  get 'admins/:id/password', to: 'admins#password', as: 'admin_password_setting'

  get 'admins/:id/profile', to: 'admins#profile', as: 'admin_profile'

  get 'admins/:id/two_factor_authentication', to: 'admins#two_factor_authentication', as: 'admin_two_factor_authentication'

  get 'admins/:id/two_factor_authentication_setting', to: 'admins#two_factor_authentication_setting', as: 'admins_two_factor_authentication_setting'

  get 'admins/:id/update', to: 'admins#update', as: 'admins_update'

  # users url
  get 'users', to: 'users#index', as: 'users'

  get 'users/:id', to: 'users#show', as: 'user'

  get 'users/:id/account', to: 'users#account', as: 'user_account'

  get 'users/:id/password', to: 'users#password', as: 'user_password_setting'

  get 'users/:id/profile', to: 'users#profile', as: 'user_profile'

  get 'users/:id/two_factor_authentication', to: 'users#two_factor_authentication', as: 'user_two_factor_authentication'

  get 'users/:id/two_factor_authentication_setting', to: 'users#two_factor_authentication_setting', as: 'users_two_factor_authentication_setting'

  get 'users/:id/unsubscribe_confirm', to: 'users#unsubscribe_confirm', as: 'users_unsubscribe_confirm'

  post 'users/:id/update', to: 'users#update', as: 'users_update'

end
