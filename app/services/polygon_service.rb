# frozen_string_literal: true

class PolygonService
  def self.coords_from_w3w_list(list)
    list.filter_map do |w3w|
      w3w_resp = W3wApiService.convert_to_coordinates(w3w)
      next unless w3w_resp.key?('square')

      t = Tile.new
      t.populate_coords_from_w3w_response(w3w_resp)
      [t.midpoint.x, t.midpoint.y].map { |x| format('%.6f', x) }.join(' ')

      # raise "FAILED to retrieve #{w3w}: #{w3w_resp}"
    end
  end

  def self.polygon_from_w3w_list(list)
    polyline = coords_from_w3w_list(list)
    polyline << polyline[0] unless polyline[0] == polyline[-1]

    "POLYGON ((#{polyline.join(', ')}))"
  end
end
