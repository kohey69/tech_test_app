Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
  }

  resources :events, only: %i[index show] do
    resource :participation, only: %i[create destroy], module: :events
  end

  namespace :my do
    resources :events
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
