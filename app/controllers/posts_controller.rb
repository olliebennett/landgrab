# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :set_post, only: %i[show]

  def show; end

  private

  def set_post
    @post = Post.find_by_hashid!(params[:id])
  end
end
