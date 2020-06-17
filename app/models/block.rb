class Block < ApplicationRecord
  def to_geojson
    box = RGeo::Cartesian::BoundingBox.create_from_points(southwest, northeast)
    RGeo::GeoJSON.encode(box.to_geometry).to_json
  end
end
