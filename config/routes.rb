Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
  }

  resources :events, only: %i[index show] do
    resource :participation, only: %i[create destroy], module: :events
    resource :favorite, only: %i[create destroy], module: :events
    resource :review, only: %i[new create destroy], module: :events
  end
  resources :review_ranking_events, only: %i[index]

  namespace :my do
    resources :events
    resources :favorite_events, only: %i[index]
    resources :participating_events, only: %i[index]
    resources :participated_events, only: %i[index]
  end

  devise_for :administrators, controllers: {
    sessions: 'admins/sessions',
  }

  namespace :admins do
    root 'home#index'
    resources :users, only: %i[index edit update destroy]
    resources :events, only: %i[index show edit update destroy] do
      resources :reviews, only: %i[destroy], module: :events
    end
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
