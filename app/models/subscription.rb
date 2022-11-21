# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :tile

  validates :stripe_id,
            format: { with: /\Asub_[0-9a-zA-Z]+\z/ },
            uniqueness: true
end
