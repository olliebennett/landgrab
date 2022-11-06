# frozen_string_literal: true

FactoryBot.define do
  factory :block do
    southwest { 'POINT(-0.001169 51.477738)' }
    northeast { 'POINT(-0.001169 51.477738)' }
    sequence(:w3w, 'a') { |n| "#{n}.#{n}.#{n}" }
  end
end
