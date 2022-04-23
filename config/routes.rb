# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root to: 'static_pages#homepage'

  resources :blocks, only: %i[create index show new]
  resources :plots, only: %i[create index show new edit update]
  resources :subscriptions, only: %i[create index show new edit update]
end
