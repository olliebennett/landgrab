namespace :block do
  desc "Populate blocks within a given region polygon"
  task populate_from_polygon: :environment do
    corner1 = RGeo::Cartesian::PointImpl.new(RGeo::Cartesian::Factory.new, '-0.02018', '51.51591')
    corner2 = RGeo::Cartesian::PointImpl.new(RGeo::Cartesian::Factory.new, '-0.01960', '51.51558')

    latmin, latmax = [corner1.y, corner2.y].minmax
    lngmin, lngmax = [corner1.x, corner2.x].minmax

    lat = latmin
    lng = lngmin
    w3w = nil # placeholder for What3Words API response
    square = nil

    while lng < lngmax
      while lat < latmax
        w3w = W3wApiService.convert_to_w3w("#{lat},#{lng}")

        # Persist block (if not already existing)
        b = Block.find_or_initialize_by(w3w: w3w.fetch('words'))
        b.populate_coords_from_w3w_response(w3w)
        b.save!

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
end
