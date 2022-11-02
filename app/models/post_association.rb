# frozen_string_literal: true

class PostAssociation < ApplicationRecord
  belongs_to :post

  belongs_to :postable, polymorphic: true
end
