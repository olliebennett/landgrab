# frozen_string_literal: true

module Admin
  class PostViewsController < ApplicationController
    before_action :check_admin

    def index
      @post_views = apply_scopes(PostView).all
      @post_views = @post_views.where(user_id: User.decode_id(params[:user])) if params[:user].present?
      @post_views = @post_views.where(post_id: Post.decode_id(params[:post])) if params[:post].present?

      respond_to do |format|
        format.html do
          @post_views = @post_views.order(id: :desc).page(params[:page])
          render :index
        end
        format.csv { render_csv('post_views') }
      end
    end
  end
end
