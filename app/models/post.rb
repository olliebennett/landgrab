# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :author, class_name: 'User', inverse_of: :posts_authored

  has_many :post_associations, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true

  # Viewable if user has subscribed to any associated block
  def viewable_by?(user)
    post_associations.any? do |pa|
      pa.postable.viewable_by?(user)
    end
  end
end
