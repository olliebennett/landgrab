# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               registrations: 'registrations'
             }
  as :user do
    get '/settings/profile' => 'registrations#edit', as: 'edit_profile'
    get '/settings/password' => 'registrations#edit_password', as: 'edit_password'
  end

  root to: 'static_pages#homepage'

  resources :tiles, only: %i[index show]
  resources :plots, only: %i[index show]
  resources :posts, only: %i[show]
  resources :projects, only: %i[index show] do
    get :welcome, on: :member
  end
  resources :subscriptions, only: %i[create index show] do
    get :claim, on: :member
    post :redeem, on: :member
  end

  post '/checkout/checkout', 'checkouts#checkout'
  get '/checkout/generate', 'checkouts#generate'
  get '/checkout/success', 'checkouts#success'
  get '/checkout/cancel', 'checkouts#cancel'
  get '/checkout/claim', 'checkouts#claim'

  get '/about', to: 'static_pages#about'
  get '/explore', to: 'static_pages#explore'
  get '/support', to: 'static_pages#support'

  namespace :admin do
    root to: 'dashboard#dashboard', as: :dashboard

    resources :tiles, only: %i[create index show new]
    resources :plots, only: %i[create index show new edit update]
    resources :posts, only: %i[create index show new edit update] do
      get :bulk_association_edit, on: :member
      post :bulk_association_update, on: :member
    end

    resources :post_associations, only: %i[create]
    resources :projects, only: %i[create index show new edit update]
    resources :promo_codes, only: %i[index]
    resources :subscriptions, only: %i[create index show edit update] do
      get :refresh, on: :member
    end
    resources :users, only: %i[index show]
  end

  namespace :webhook do
    post '/stripe' => 'stripe#webhook'
  end
end
