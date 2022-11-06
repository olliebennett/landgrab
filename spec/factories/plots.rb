# frozen_string_literal: true

FactoryBot.define do
  factory :plot do
    title { 'Test Plot' }
    polygon { 'POLYGON ((-0.02018 51.51576, -0.02002 51.51591, -0.01981 51.51558, -0.02018 51.51576))' }
  end
end
