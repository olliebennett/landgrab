# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: :user_id, inverse_of: :comments_authored
  belongs_to :post

  validates :text, presence: true

  auto_strip_attributes :text, squish: true
end
