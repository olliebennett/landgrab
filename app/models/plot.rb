# frozen_string_literal: true

class Plot < ApplicationRecord
  belongs_to :project, optional: true
  has_many :blocks, dependent: :nullify

  default_scope { order(:id) }

  validates :title, presence: true
  validates :polygon, presence: true

  validate :validate_bounding_box_dimensions
  validate :validate_overlapping_polygons

  auto_strip_attributes :title, squish: true

  scope :with_available_blocks, -> { left_joins(blocks: :subscription).where(subscription: { id: nil }) }

  MAX_BOUNDING_BOX_DIMENSION = 0.005
  DEFAULT_COORDS = [51.4778, -0.0014].freeze # Greenwich Observatory

  def centroid_coords
    RGeo::Cartesian::PointImpl.new(RGeo::Cartesian::Factory.new, polygon.centroid.x, polygon.centroid.y)
  end

  def centroid_coords_display
    [centroid_coords.x, centroid_coords.y].map { |x| format('%.6f', x) }.join(', ')
  end

  def bounding_box
    x_coords = polygon.coordinates[0].pluck(0)
    y_coords = polygon.coordinates[0].pluck(1)

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

  def area_formatted_acres
    "#{format('%.3f', area / 4046.86)} acres"
  end

  def coordinates_display
    polygon.coordinates[0].map do |coord|
      coord.map { |x| format('%.6f', x) }
    end.to_s.delete('"')
  end

  def non_subscribed_blocks
    blocks.where.missing(:subscription)
  end

  def validate_bounding_box_dimensions
    errors.add(:polygon, 'is too wide') if bounding_box.x_span > MAX_BOUNDING_BOX_DIMENSION
    errors.add(:polygon, 'is too high') if bounding_box.y_span > MAX_BOUNDING_BOX_DIMENSION
  end

  def validate_overlapping_polygons
    overlaps = overlapping_polygons
    return if overlaps.blank?

    errors.add(:polygon, "intersects with other plot(s) - Plot #{overlaps.map(&:hashid).join(', ')}")
  end

  def overlapping_polygons
    return nil if polygon.nil?

    Plot \
      .select('plots.id, plots.title, plots.polygon')
      .joins('INNER JOIN plots p2 ON plots.id != p2.id')
      .where('ST_Intersects(plots.polygon, ST_GeomFromText(?, 0))', polygon.as_json)
      .where.not(id:)
      .distinct
  end
end
