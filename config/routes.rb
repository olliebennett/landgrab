# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root to: 'static_pages#homepage'

  resources :blocks, only: %i[index show]
  resources :plots, only: %i[index show]
  resources :projects, only: %i[index show]
  resources :subscriptions, only: %i[create index show]

  post '/checkout/checkout', 'checkouts#checkout'
  get '/checkout/success', 'checkouts#success'
  get '/checkout/cancel', 'checkouts#cancel'

  get '/about', to: 'static_pages#about'
  get '/explore', to: 'static_pages#explore'

  namespace :admin do
    root to: 'dashboard#dashboard', as: :dashboard

    resources :blocks, only: %i[create index show new]
    resources :plots, only: %i[create index show new edit update]
    resources :projects, only: %i[create index show new edit update]
    resources :subscriptions, only: %i[create index show edit update]
    resources :users, only: %i[index show]
  end

  namespace :webhook do
    post '/stripe' => 'stripe#webhook'
  end
end
