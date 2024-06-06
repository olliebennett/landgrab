# frozen_string_literal: true

class Tag < ApplicationRecord
  belongs_to :post

  validates :title, presence: true
end
