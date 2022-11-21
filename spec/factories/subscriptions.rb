# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    tile
    user

    sequence(:stripe_id) { |n| "sub_#{n}" }
  end
end
