Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
  }

  namespace :my do
    resources :events
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
