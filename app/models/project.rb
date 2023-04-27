# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :plots, dependent: :restrict_with_exception

  has_many :post_associations, as: :postable, inverse_of: :postable, dependent: :restrict_with_exception
  has_many :posts, through: :post_associations

  validates :title, presence: true
  validates :hero_image_url, url: true, allow_blank: true
  validates :logo_url, url: true, allow_blank: true
  validates :website, url: true, allow_blank: true

  auto_strip_attributes :title, squish: true
  auto_strip_attributes :description, :welcome_text, :subscriber_benefits

  def viewable_by?(user)
    tiles_subscribed_by(user).any?
  end

  def tiles_subscribed_by(user)
    Tile.joins(latest_subscription: :user, plot: :project)
        .where(projects: { id: })
        .where(users: { id: user.id })
  end
end
