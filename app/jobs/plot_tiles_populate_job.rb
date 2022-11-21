# frozen_string_literal: true

class PlotTilesPopulateJob < ApplicationJob
  queue_as :default

  def perform(plot_id)
    @plot = Plot.find(plot_id)

    clear_outlier_tiles

    populate_internal_tiles
  end

  private

  def clear_outlier_tiles
    @plot.tiles.each do |t|
      next if t.within_plot?(@plot)

      # Remove this tile from the plot
      puts "Removing tile... #{t.w3w}"
      t.update!(plot: nil)
    end
  end

  def populate_internal_tiles
    bb = @plot.bounding_box

    latmin, latmax = [bb.min_point.y, bb.max_point.y].minmax
    lngmin, lngmax = [bb.min_point.x, bb.max_point.x].minmax

    lat = latmin
    lng = lngmin

    while lng < lngmax
      while lat < latmax
        sleep 0.2
        w3w = W3wApiService.convert_to_w3w("#{lat},#{lng}")

        t = persist_tile(w3w)

        tile_mid = t.midpoint
        tile_maxlat = [t.southwest.y, t.northeast.y].max

        puts "Tile[lng=#{format('%.6f', tile_mid.y)}; lat=#{format('%.6f', tile_mid.x)}] => #{t.w3w}"
        # Increment latitude, just into next tile's area
        lat = tile_maxlat + 0.000001
      end
      puts '-' * 10
      # Increment longitude; move just beyond latest result's max longitude
      tile_maxlng = [t.southwest.x, t.northeast.x].max
      lng = tile_maxlng + 0.000001
      lat = latmin
    end
  end

  def persist_tile(w3w)
    # Persist tile (if not already existing)
    t = Tile.find_or_initialize_by(w3w: w3w.fetch('words'))
    t.populate_coords_from_w3w_response(w3w)
    if t.within_plot?(@plot)
      puts "Tile #{t.midpoint_rounded} is WITHIN plot; saving!"
      t.plot = @plot
      t.save!
    else
      puts "Tile #{t.midpoint_rounded} is OUTSIDE plot; skipping!"
    end
    t
  end
end
