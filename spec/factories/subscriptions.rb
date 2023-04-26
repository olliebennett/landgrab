# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    tile { nil }
    user { nil }

    sequence(:stripe_id) { |n| "sub_#{n}" }
  end
end
