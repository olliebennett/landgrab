# frozen_string_literal: true

class Team < ApplicationRecord
  has_many :users, dependent: :nullify

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
end
