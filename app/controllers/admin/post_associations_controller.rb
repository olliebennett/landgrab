# frozen_string_literal: true

module Admin
  class PostAssociationsController < ApplicationController
    before_action :check_admin

    def create
      @post_association = PostAssociation.new(post_association_params)
      @post = @post_association.post

      if @post_association.save
        redirect_to admin_post_path(@post), notice: 'Post association was successfully created.'
      else
        render :new
      end
    end

    private

    def post_association_params
      params.require(:post_association).permit(:postable_type, :postable_id, :post_id).tap do |tmp|
        tmp[:post_id] = Post.decode_id(tmp[:post_id])
        tmp[:postable_id] = \
          case tmp[:postable_type]
          when 'Project'
            Project.decode_id(tmp[:postable_id])
          when 'Plot'
            Plot.decode_id(tmp[:postable_id])
          when 'Tile'
            Tile.decode_id(tmp[:postable_id])
          else
            raise "Unexpected postable_type: #{tmp[:postable_type]}"
          end
      end
    end
  end
end
