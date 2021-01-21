Rails.application.routes.draw do
  root to: 'static_pages#homepage'

  resources :plots, only: %i[create index show new]
  resources :blocks, only: %i[create index show new]
end
