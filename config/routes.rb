Rails.application.routes.draw do

  get 'notifications/link_through'

  resources 'uploads', only: [:create, :destroy]

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
  registrations: 'users/registrations',
  omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    get '/logout', to: 'devise/sessions#destroy', as: 'logout'
  end

  resource :two_factor_auth, only: [:new, :create, :destroy]

  # admins
  resources :admins, only: [ :index, :create, :edit, :show, :update]

  get 'admins/:id/password', to: 'admins#password', as: 'admin_password_setting'

  get 'admins/:id/profile', to: 'admins#profile', as: 'admin_profile'

  get 'admins/:id/two_factor_authentication', to: 'admins#two_factor_authentication', as: 'admin_two_factor_authentication'

  get 'admins/:id/two_factor_authentication_setting', to: 'admins#two_factor_authentication_setting', as: 'admins_two_factor_authentication_setting'

  # users
  resources :users, only: [ :index, :create, :edit, :show, :update] do
    resources :drafts do
      member do
        get 'confirm'
        post 'create_article'
      end
    end
    member do
     get :following, :followers
    end
  end

  get 'users/:id/favorites', to: 'users#favorites', as: 'favorites'

  get 'users/:id/comments', to: 'users#comments', as: 'comments'

  get 'users/:id/followers', to: 'users#followers', as: 'followers'

  get 'users/:id/followings', to: 'users#followings', as: 'followings'

  get 'users/:id/account', to: 'users#account', as: 'user_account'

  get 'users/:id/password', to: 'users#password', as: 'user_password_setting'

  patch 'users/:id/update_password', to: 'users#update_password', as: 'update_password'

  get 'users/:id/profile', to: 'users#profile', as: 'user_profile'

  get 'users/:id/two_factor_authentication', to: 'users#two_factor_authentication', as: 'user_two_factor_authentication'

  get 'users/:id/two_factor_authentication_setting', to: 'users#two_factor_authentication_setting', as: 'user_two_factor_authentication_setting'

  get 'users/:id/confirm_unsubscribe', to: 'users#confirm_unsubscribe', as: 'confirm_unsubscribe'

  patch 'users/:id/unsubscribe', to: 'users#unsubscribe', as: 'unsubscribe'

  # relationships
  resources :relationships, only: [:create, :destroy]

  # articles
  resources :articles do
    resources :comments, only: [ :index, :create, :show, :update, :destroy]
    resource :images, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
    resource :keeps, only: [:create, :destroy]
    collection do
      post 'confirm'
    end
  end

  get 'user_timeline', to: 'articles#user_timeline', as: 'user_timeline'

  get 'tag_timeline', to: 'articles#tag_timeline', as: 'tag_timeline'

  get 'articles/:id/confirm_edit', to: 'articles#confirm_edit', as: 'confirm_edit'

  # keeps
  resources :keeps, only: [:index]

  # tags
  resources :tags, only: [ :index, :create, :show, :update] do
    collection do
      post 'add'
    end
  end

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

  # posts
  resources :posts

  # notifications
  resources :notifications

  get 'notifications', to: 'notifications#index'

  get 'notifications/:id/link_through', to: 'notifications#link_through', as: :link_through

end
