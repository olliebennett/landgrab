Rails.application.routes.draw do
  root to: 'static_pages#homepage'

  resources :plots, only: %i[index show new]
  resources :blocks, only: %i[index show new]
end
