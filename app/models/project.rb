# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :plots, dependent: :restrict_with_exception

  has_many :post_associations, as: :postable, inverse_of: :postable, dependent: :restrict_with_exception
  has_many :posts, through: :post_associations
end
