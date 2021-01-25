class Plot < ApplicationRecord
  has_many :blocks, dependent: :nullify

  validates :title, presence: true
  validates :polygon, presence: true

  validate :validate_bounding_box_dimensions

  MAX_BOUNDING_BOX_DIMENSION = 0.005

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

  def bounding_box_area
    bounding_box.x_span * bounding_box.y_span
  end

  def validate_bounding_box_dimensions
    errors.add(:polygon, 'is too wide') if bounding_box.x_span > MAX_BOUNDING_BOX_DIMENSION
    errors.add(:polygon, 'is too high') if bounding_box.y_span > MAX_BOUNDING_BOX_DIMENSION
  end
end
