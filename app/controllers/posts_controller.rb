# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :set_post, only: %i[show]
  skip_before_action :authenticate_user!, only: %i[show]

  def show
    if params[:access_key].present?
      shared_post_view = @post.post_views.find_by(shared_access_key: params[:access_key])
      @sharer = shared_post_view.user if shared_post_view
    end

    @viewable = (user_signed_in? && @post.viewable_by?(current_user)) || @sharer.present?

    @latest_post_view = latest_post_view if user_signed_in?

    log_event_mixpanel('Posts: Show', { authed: user_signed_in?, viewable: @viewable })
  end

  private

  def latest_post_view
    @post.post_views
         .where(user: current_user)
         .where('created_at > ?', 1.hour.ago)
         .first ||
      @post.post_views
           .create!(user: current_user, shared_access_key: SecureRandom.hex)
  end

  def set_post
    @post = Post.find_by_hashid!(params[:id])
  end
end
