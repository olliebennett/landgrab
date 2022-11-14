# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title { 'My Post Title' }
    body { 'My Post Body' }

    association :author, factory: :user
  end
end
