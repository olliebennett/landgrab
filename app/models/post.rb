# frozen_string_literal: true

class Post < ApplicationRecord
  attr_accessor :publish_immediately

  belongs_to :author, class_name: 'User', inverse_of: :posts_authored

  has_many :post_associations, dependent: :destroy
  has_many :comments, dependent: :restrict_with_exception

  validates :title, presence: true
  validates :body, presence: true

  scope :published, -> { where('published_at IS NOT NULL AND published_at <= ?', Time.zone.now) }
  scope :unpublished, -> { where('published_at IS NULL OR published_at > ?', Time.zone.now) }

  W3W_REGEX = %r{/{3}([a-z]+\.[a-z]+\.[a-z]+)}

  def associated_tiles
    post_associations.where(postable_type: 'Tile').includes(:postable).map(&:postable)
  end

  def associated_plots
    post_associations.where(postable_type: 'Plot').includes(:postable).map(&:postable)
  end

  def associated_projects
    post_associations.where(postable_type: 'Project').includes(:postable).map(&:postable)
  end

  def mentioned_w3w
    body.scan(W3W_REGEX).uniq.map(&:first)
  end

  def mentioned_tiles
    Tile.where(w3w: mentioned_w3w)
  end

  # Viewable if user has subscribed to any associated tile
  def viewable_by?(user)
    post_associations.includes(:postable).any? do |pa|
      pa.postable.viewable_by?(user)
    end
  end
end
