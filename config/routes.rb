require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users,
             controllers: {
               invitations: 'users/invitations',
               sessions: 'users/sessions'
             },
             skip: [:registrations]

  root to: 'site/home#index'

  get 'about', to: 'site/about#index'

  namespace :admin do
    resources :organizations, only: [:edit, :index, :show, :update]
    resources :integrations, except: [:destroy]
    resources :users
  end
  resources :entities, only: [:index, :show]
end
