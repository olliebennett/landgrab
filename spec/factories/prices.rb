# frozen_string_literal: true

FactoryBot.define do
  factory :price do
    title { 'Test Price' }
    amount_display { '$10.00 / month' }
    sequence(:stripe_id) { |n| "price_#{n}" }
    project
  end
end
