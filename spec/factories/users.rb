# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { 'Freya' }
    last_name { 'Stark' }
    admin { false }
    sequence(:email) { |n| "user-#{n}@example.com" }
    password { 'password' }
  end
end
