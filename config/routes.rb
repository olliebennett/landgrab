# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'static_pages#homepage'

  resources :plots, only: %i[create index show new edit update]
  resources :blocks, only: %i[create index show new]
end
