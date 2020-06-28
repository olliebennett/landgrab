Rails.application.routes.draw do
  resources :plots
  resources :blocks
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'static_pages#homepage'
end
