# frozen_string_literal: true

class PlotBlocksPopulateJob < ApplicationJob
  queue_as :default

  def perform(plot_id)
    plot = Plot.find(plot_id)
    bb = plot.bounding_box

    latmin, latmax = [bb.min_point.y, bb.max_point.y].minmax
    lngmin, lngmax = [bb.min_point.x, bb.max_point.x].minmax

    lat = latmin
    lng = lngmin
    square = nil

    while lng < lngmax
      while lat < latmax
        w3w = W3wApiService.convert_to_w3w("#{lat},#{lng}")

        persist_block(w3w)

        block_mid = w3w.fetch('coordinates')
        square = w3w.fetch('square')
        block_maxlat = [square.fetch('southwest').fetch('lat'), square.fetch('northeast').fetch('lat')].max

        puts "Block[lng=#{format('%.6f', block_mid.fetch('lng'))}; lat=#{format('%.6f', block_mid.fetch('lat'))}] => #{w3w.fetch('words')}"
        sleep 0.5
        # Increment latitude, just into next block's area
        lat = block_maxlat + 0.000001
      end
      puts '-' * 10
      # Increment longitude; move just beyond latest result's max longitude
      block_maxlng = [square.fetch('southwest').fetch('lng'), square.fetch('northeast').fetch('lng')].max
      lng = block_maxlng + 0.000001
      lat = latmin
    end
  end

  private

  def persist_block(w3w)
    # Persist block (if not already existing)
    b = Block.find_or_initialize_by(w3w: w3w.fetch('words'))
    b.populate_coords_from_w3w_response(w3w)
    if b.within_plot?(plot)
      puts "Block #{b.midpoint_rounded} is WITHIN plot; saving!"
      b.plot = plot
      b.save!
    else
      puts "Block #{b.midpoint_rounded} is OUTSIDE plot; skipping!"
    end
  end
end
