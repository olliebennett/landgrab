# frozen_string_literal: true

class PlotTilesPopulateJob < ApplicationJob
  queue_as :default

  def perform(plot_id)
    @plot = Plot.find(plot_id)

    @plot.update!(tile_population_status: :in_progress)

    clear_outlier_tiles

    populate_internal_tiles

    @plot.update!(tile_population_status: :succeeded)
  rescue StandardError => e
    @plot.update!(tile_population_status: :errored)
    raise e
  end

  private

  def clear_outlier_tiles
    @plot.tiles.find_each do |t|
      next if t.within_plot?(@plot)

      # Remove this tile from the plot
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
        t = existing_tile(lng, lat) || fetch_and_persist_new_tile(lat, lng)

        # tile_mid = t.midpoint
        tile_maxlat = [t.southwest.y, t.northeast.y].max

        # puts "Tile[lng=#{format('%.6f', tile_mid.y)}; lat=#{format('%.6f', tile_mid.x)}] => #{t.w3w}"
        # Increment latitude, just into next tile's area
        lat = tile_maxlat + 0.000001
      end
      # Increment longitude; move just beyond latest result's max longitude
      tile_maxlng = [t.southwest.x, t.northeast.x].max
      lng = tile_maxlng + 0.000001
      lat = latmin
    end
  end

  def build_point(lat, lng)
    RGeo::Cartesian::PointImpl.new(RGeo::Cartesian::Factory.new, lat, lng)
  end

  def tiles_to_check
    # We include 'orphaned' (plot=nil) tiles here in case we
    # recently cleared them while editing this (or a nearby) plot.
    @tiles_to_check ||= Tile.where(plot_id: [nil, @plot.id]).to_a
  end

  def existing_tile(lat, lng)
    point = build_point(lat, lng)
    tiles_to_check.detect do |tile|
      tile.bounding_box.contains?(point)
    end
  end

  def fetch_and_persist_new_tile(lat, lng)
    sleep 0.2 # go easy on W3W API
    w3w = W3wApiService.convert_to_w3w("#{lat},#{lng}")
    persist_tile(w3w)
  end

  def persist_tile(w3w)
    # Persist tile (if not already existing)
    t = Tile.find_or_initialize_by(w3w: w3w.fetch('words'))
    t.populate_coords_from_w3w_response(w3w)
    if t.within_plot?(@plot)
      t.plot = @plot
      t.save!
    end
    t
  end
end
