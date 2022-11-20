# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    block
    user

    sequence(:stripe_id) { |n| "sub_#{n}" }
  end
end
