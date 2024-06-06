# frozen_string_literal: true

module Admin
  class TagsController < ApplicationController
    def index
      @tags = Tag.all
    end

    def create
      @tag = Tag.new(tag_params)
      @tag.save!
      redirect_back fallback_location: admin_post_path(@tag.post), notice: 'Tag was successfully created.'
    end

    private

    def tag_params
      params.require(:tag).permit(:title, :post_id).tap do |temp_params|
        temp_params[:post_id] = Post.decode_id(temp_params[:post_id])
      end
    end
  end
end
