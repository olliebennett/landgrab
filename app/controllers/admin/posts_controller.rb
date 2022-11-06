# frozen_string_literal: true

module Admin
  class PostsController < ApplicationController
    before_action :check_admin
    before_action :set_post, only: %i[show edit update]

    def index
      @posts = Post.order(id: :desc).page(params[:page])
    end

    def show
      @post_association = @post.post_associations.new
    end

    def new
      @post = Post.new
    end

    def edit; end

    def create
      @post = Post.new(post_params)
      @post.author = current_user

      respond_to do |format|
        if @post.save
          format.html { redirect_to admin_post_path(@post), notice: 'Post was successfully created.' }
        else
          format.html { render :new }
        end
      end
    end

    def update
      respond_to do |format|
        if @post.update(post_params)
          format.html { redirect_to admin_post_path(@post), notice: 'Post was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    end

    private

    def set_post
      @post = Post.find_by_hashid!(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body)
    end
  end
end
