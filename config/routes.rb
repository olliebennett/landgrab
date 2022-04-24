# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root to: 'static_pages#homepage'

  resources :blocks, only: %i[index show]
  resources :plots, only: %i[index show]
  resources :subscriptions, only: %i[create index show]

  namespace :admin do
    root to: 'admin#dashboard', as: :dashboard

    resources :blocks, only: %i[create index show new]
    resources :plots, only: %i[create index show new edit update]
    resources :subscriptions, only: %i[create index show edit update]
  end
end
