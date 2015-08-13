Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               invitations: 'users/invitations',
               sessions: 'users/sessions'
             },
             skip: [:registrations]

  root to: 'site/home#index'

  get 'about', to: 'site/about#index'

  namespace :admin do
    resources :users
  end
end
