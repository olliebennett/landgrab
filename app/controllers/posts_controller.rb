# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :set_post, only: %i[show]
  skip_before_action :authenticate_user!, only: %i[show]

  def show
    @viewable = user_signed_in? && @post.viewable_by?(current_user)
    log_event_mixpanel('Posts: Show', { authed: user_signed_in?, viewable: @viewable })
  end

  private

  def set_post
    @post = Post.find_by_hashid!(params[:id])
  end
end
