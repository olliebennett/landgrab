# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title { 'My Post Title' }
    body { 'My Post Body' }

    author factory: %i[user]
  end
end
