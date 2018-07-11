Rails.application.routes.draw do

  # root
  root to: 'articles#index'

  # devise
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

  # admins
  resources :admins, only: [ :index, :create, :edit, :show, :update]

  get 'admins/:id/password', to: 'admins#password', as: 'admin_password_setting'

  get 'admins/:id/profile', to: 'admins#profile', as: 'admin_profile'

  get 'admins/:id/two_factor_authentication', to: 'admins#two_factor_authentication', as: 'admin_two_factor_authentication'

  get 'admins/:id/two_factor_authentication_setting', to: 'admins#two_factor_authentication_setting', as: 'admins_two_factor_authentication_setting'

  # users
  resources :users, only: [ :index, :create, :edit, :show, :update] do
    member do
     get :following, :followers
    end
  end

  # relationships
  resources :relationships, only: [:create, :destroy]

  get 'users/:id/account', to: 'users#account', as: 'user_account'

  get 'users/:id/password', to: 'users#password', as: 'user_password_setting'

  get 'users/:id/profile', to: 'users#profile', as: 'user_profile'

  get 'users/:id/two_factor_authentication', to: 'users#two_factor_authentication', as: 'user_two_factor_authentication'

  get 'users/:id/two_factor_authentication_setting', to: 'users#two_factor_authentication_setting', as: 'users_two_factor_authentication_setting'

  get 'users/:id/unsubscribe_confirm', to: 'users#unsubscribe_confirm', as: 'users_unsubscribe_confirm'

  # articles
  resources :articles do
    resources :comments, only: [ :index, :create, :show, :update, :destroy]
    resource :images, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end

  get 'user_timeline', to: 'articles#user_timeline', as: 'user_timeline'

  get 'tag_timeline', to: 'articles#tag_timeline', as: 'tag_timeline'

  get 'articles/confirm', to: 'articles#confirm', as: 'confirm_article'

  get 'articles/:id/edit_confirm', to: 'articles#edit_confirm', as: 'confirm_edit_article'

  # drafts
  resources :drafts

  get 'drafts/confirm', to: 'drafts#confirm', as: 'confirm_draft'

  # keeps
  resources :keeps, only: [ :index, :create, :update, :destroy]

  # tags
  resources :tags, only: [ :index, :create, :show, :update]

  # taggings
  resources :taggings, only: [ :destroy]

  # contacts
  resources :contacts, only: [ :index, :create, :new, :show, :update]

  get 'contacts/confirm', to: 'contacts#confirm', as: 'confirm_contact'

  get 'contacts/sent', to: 'contacts#sent', as: 'sent_contact'

  # terms
  get 'terms', to: 'terms#index', as: 'terms'

  # help
  get 'help', to: 'helps#index', as: 'helps'

end
