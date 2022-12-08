# frozen_string_literal: true

class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[about homepage explore]

  def about; end

  def support; end

  def homepage
    if params[:center].present?
      tile = Tile.find_by(w3w: params[:center])
      @center = [tile.midpoint.y, tile.midpoint.x] if tile
    else
      @center = Plot::DEFAULT_COORDS
    end
  end

  def explore
    @plot = Plot.select('plots.id, plots.title, COUNT(tiles)')
                .with_available_tiles
                .group('plots.id')
                .sample

    return redirect_to root_url, flash: { danger: 'No plots exist yet so nothing to explore!' } if @plot.nil?

    @available_limit = 200
    @available_tiles = @plot.tiles.available.sample(@available_limit)
    @unavailable_tiles = @plot.tiles.unavailable.distinct.sample(250 - @available_tiles.size)
  end
end
