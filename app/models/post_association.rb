# frozen_string_literal: true

class PostAssociation < ApplicationRecord
  belongs_to :post

  belongs_to :postable, polymorphic: true

  validates :postable_id,
            uniqueness: {
              scope: %i[postable_type post],
              message: 'is already associated with this post'
            }
end
