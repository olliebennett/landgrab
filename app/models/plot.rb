class Plot < ApplicationRecord
  has_many :blocks

  validates :title, presence: true
  validates :polygon, presence: true
end
