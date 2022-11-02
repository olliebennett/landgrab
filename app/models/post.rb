# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :author, class_name: 'User', inverse_of: :posts_authored

  has_many :post_associations, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true
end
