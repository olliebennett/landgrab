# frozen_string_literal: true

class PlotTilesPopulateJob < ApplicationJob
  queue_as :default

  def perform(plot_id)
    @plot = Plot.find(plot_id)
    bb = @plot.bounding_box

    latmin, latmax = [bb.min_point.y, bb.max_point.y].minmax
    lngmin, lngmax = [bb.min_point.x, bb.max_point.x].minmax

    lat = latmin
    lng = lngmin
    square = nil

    while lng < lngmax
      while lat < latmax
        w3w = W3wApiService.convert_to_w3w("#{lat},#{lng}")

        persist_tile(w3w)

        tile_mid = w3w.fetch('coordinates')
        square = w3w.fetch('square')
        tile_maxlat = [square.fetch('southwest').fetch('lat'), square.fetch('northeast').fetch('lat')].max

        puts "Tile[lng=#{format('%.6f', tile_mid.fetch('lng'))}; lat=#{format('%.6f', tile_mid.fetch('lat'))}] => #{w3w.fetch('words')}"
        sleep 0.5
        # Increment latitude, just into next tile's area
        lat = tile_maxlat + 0.000001
      end
      puts '-' * 10
      # Increment longitude; move just beyond latest result's max longitude
      tile_maxlng = [square.fetch('southwest').fetch('lng'), square.fetch('northeast').fetch('lng')].max
      lng = tile_maxlng + 0.000001
      lat = latmin
    end
  end

  private

  def persist_tile(w3w)
    # Persist tile (if not already existing)
    b = Tile.find_or_initialize_by(w3w: w3w.fetch('words'))
    b.populate_coords_from_w3w_response(w3w)
    if b.within_plot?(@plot)
      puts "Tile #{b.midpoint_rounded} is WITHIN plot; saving!"
      b.plot = @plot
      b.save!
    else
      puts "Tile #{b.midpoint_rounded} is OUTSIDE plot; skipping!"
    end
  end
end
