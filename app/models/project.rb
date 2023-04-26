# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :plots, dependent: :restrict_with_exception

  has_many :post_associations, as: :postable, inverse_of: :postable, dependent: :restrict_with_exception
  has_many :posts, through: :post_associations

  validates :title, presence: true

  def viewable_by?(user)
    tiles_subscribed_by(user).any?
  end

  def tiles_subscribed_by(user)
    Tile.joins(latest_subscription: :user, plot: :project)
        .where(projects: { id: })
        .where(users: { id: user.id })
  end
end
