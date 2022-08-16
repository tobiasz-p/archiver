# frozen_string_literal: true

Rails.application.routes.draw do
  mount API => '/'

  root to: 'attachments#index'

  resources :users, only: [:new, :create]

  # sessions routes
  get '/login',     to: 'sessions#new', as: 'login'
  post '/login',    to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: 'logout'

  resources :attachments, only: %i[new create]
end
