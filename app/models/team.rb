# frozen_string_literal: true

class Team < ApplicationRecord
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
end
