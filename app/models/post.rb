# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :author, class_name: 'User', inverse_of: :posts_authored

  validates :title, presence: true
  validates :body, presence: true
end
