# frozen_string_literal: true

class TilesController < ApplicationController
  before_action :set_tile, only: %i[show]
  before_action :ensure_stripe_enrollment, only: %i[show]
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    log_event_mixpanel('Tiles: Index', { authed: user_signed_in? })
    @plot = Plot.find_by_hashid!(params[:plot]) if params[:plot].present?
    if @plot.present?
      @tiles = @plot.tiles.order(id: :desc).includes(:subscription).page(params[:page])
      @center = [@plot.centroid_coords.y, @plot.centroid_coords.x]
    else
      @tiles = Tile.order(id: :desc).includes(:plot, :subscription).page(params[:page])
      if @tiles.none?
        @center = Plot::DEFAULT_COORDS
      else
        mean_x = @tiles.sum { |b| b.midpoint.x } / @tiles.size
        mean_y = @tiles.sum { |b| b.midpoint.y } / @tiles.size

        @center = [mean_y, mean_x]
      end
    end
  end

  def show
    log_event_mixpanel('Tiles: Show', { authed: user_signed_in?, tile: @tile.hashid, plot: @tile.plot&.hashid, project: @tile.plot&.project&.hashid })
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @tile.to_geojson }
    end
  end

  private

  def set_tile
    @tile = Tile.find_by_hashid!(params[:id])
  end
end
