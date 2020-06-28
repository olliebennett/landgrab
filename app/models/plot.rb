class Plot < ApplicationRecord
  has_many :blocks

  validates :title, presence: true
  validates :polygon, presence: true

  def centroid_coords
    RGeo::Cartesian::PointImpl.new(RGeo::Cartesian::Factory.new, polygon.centroid.x, polygon.centroid.y)
  end

  def bounding_box
    x_coords = polygon.coordinates[0].map { |coord| coord[0] }
    y_coords = polygon.coordinates[0].map { |coord| coord[1] }

    northeast = RGeo::Cartesian::PointImpl.new(RGeo::Cartesian::Factory.new, x_coords.max, y_coords.max)
    southwest = RGeo::Cartesian::PointImpl.new(RGeo::Cartesian::Factory.new, x_coords.min, y_coords.min)

    RGeo::Cartesian::BoundingBox.create_from_points(southwest, northeast)
  end
end
