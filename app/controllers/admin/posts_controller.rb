# frozen_string_literal: true

module Admin
  class PostsController < ApplicationController
    before_action :check_admin
    before_action :set_post, only: %i[show edit update bulk_association_edit bulk_association_update]

    def index
      @posts = Post.order(id: :desc).page(params[:page])
    end

    def show; end

    def new
      @post = Post.new
    end

    def edit
      @post_association = @post.post_associations.new
    end

    def create
      @post = Post.new(post_params)
      @post.author = current_user

      if @post.save
        redirect_to admin_post_path(@post), notice: 'Post was successfully created.'
      else
        render :new
      end
    end

    def update
      if @post.update(post_params)
        redirect_to admin_post_path(@post), notice: 'Post was successfully updated.'
      else
        render :edit
      end
    end

    def bulk_association_edit
      @plot = Plot.find_by_hashid!(params[:plot]) if params[:plot].present?
    end

    def bulk_association_update; end

    private

    def set_post
      @post = Post.find_by_hashid!(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :preview, :body)
    end
  end
end
