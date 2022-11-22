# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :tile

  validates :stripe_id,
            format: { with: /\Asub_[0-9a-zA-Z]+\z/ },
            uniqueness: true

  # https://stripe.com/docs/api/subscriptions/object#subscription_object-status
  enum :stripe_status,
       %i[active past_due unpaid canceled incomplete incomplete_expired trialing],
       prefix: :stripe_status
end
