# frozen_string_literal: true

class BlocksController < ApplicationController
  before_action :set_block, only: %i[show]

  def index
    @plot = Plot.find_by_hashid!(params[:plot]) if params[:plot].present?
    if @plot.present?
      @blocks = @plot.blocks.order(id: :desc).includes(:subscription).page(params[:page])
      @center = [@plot.centroid_coords.y, @plot.centroid_coords.x]
    else
      @blocks = Block.order(id: :desc).includes(:plot, :subscription).page(params[:page])
      if @blocks.none?
        @center = Plot::DEFAULT_COORDS
      else
        mean_x = @blocks.sum { |b| b.midpoint.x } / @blocks.size
        mean_y = @blocks.sum { |b| b.midpoint.y } / @blocks.size

        @center = [mean_y, mean_x]
      end
    end
  end

  def show
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @block.to_geojson }
    end
  end

  private

  def set_block
    @block = Block.find_by_hashid!(params[:id])
  end
end
