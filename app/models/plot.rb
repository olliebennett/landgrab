# frozen_string_literal: true

class Plot < ApplicationRecord
  include Hashid::Rails

  has_many :blocks, dependent: :nullify

  default_scope { order(:id) }

  validates :title, presence: true
  validates :polygon, presence: true

  validate :validate_bounding_box_dimensions

  auto_strip_attributes :title, squish: true

  MAX_BOUNDING_BOX_DIMENSION = 0.005
  DEFAULT_COORDS = [51.4778, -0.0014] # Greenwich Observatory

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

  def area
    # See https://gis.stackexchange.com/questions/153192
    query = ActiveRecord::Base.sanitize_sql(['SELECT
      ST_Area(
        geography(
          ST_Transform(
            ST_GeomFromText(?, 4326),
            4326
          )
        )
      ) AS area;
    ', polygon.as_json])

    ActiveRecord::Base.connection.execute(query)[0]['area'].to_f
  end

  def area_formatted_unsquared
    if area <= 100_000
      "#{format('%.1f', area)} m"
    elsif area <= 1_000_000
      "#{format('%.2g', area / 1_000_000)} km"
    end
  end

  def coordinates_display
    polygon.coordinates[0].map do |coord|
      coord.map { |x| format('%.6f', x) }
    end.to_s.gsub('"', '')
  end

  def validate_bounding_box_dimensions
    errors.add(:polygon, 'is too wide') if bounding_box.x_span > MAX_BOUNDING_BOX_DIMENSION
    errors.add(:polygon, 'is too high') if bounding_box.y_span > MAX_BOUNDING_BOX_DIMENSION
  end
end
