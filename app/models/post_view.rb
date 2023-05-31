# frozen_string_literal: true

class PostView < ApplicationRecord
  belongs_to :user
  belongs_to :post
end
