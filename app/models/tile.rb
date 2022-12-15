# frozen_string_literal: true

class Tile < ApplicationRecord
  after_initialize :sanitize_w3w

  attr_accessor :map_popup

  belongs_to :plot, optional: true
  has_one :subscription, dependent: :restrict_with_exception
  has_many :post_associations, as: :postable, inverse_of: :postable, dependent: :restrict_with_exception
  has_many :posts, through: :post_associations

  default_scope { order(:id) }

  scope :available, -> { where.missing(:subscription) }
  scope :unavailable, -> { joins(:subscription).distinct }

  validates :southwest, :northeast, presence: true

  validates :w3w, presence: true, format: { with: /\A[a-z]+\.[a-z]+\.[a-z]+\z/, message: 'format should be a.b.c' }

  auto_strip_attributes :w3w, squish: true

  def to_geojson
    geojson = RGeo::GeoJSON.encode(bounding_box.to_geometry)

    geojson['properties'] ||= {}
    geojson['properties']['available'] = available?
    geojson['properties']['popupContent'] = popup_content
    geojson['properties']['focussed'] = map_popup
    geojson['properties']['link'] = Rails.application.routes.url_helpers.tile_path(self)

    geojson.to_json
  end

  def available?
    subscription.nil? || subscription.new_record? # handle display on 'new' screen
  end

  def unavailable?
    !available?
  end

  def popup_content
    return unless map_popup

    "///#{w3w}"
  end

  def w3w_url
    "https://what3words.com/#{w3w}"
  end

  def bounding_box
    RGeo::Cartesian::BoundingBox.create_from_points(southwest, northeast)
  end

  def midpoint
    RGeo::Cartesian::PointImpl.new(RGeo::Cartesian::Factory.new, bounding_box.center_x, bounding_box.center_y)
  end

  def within_plot?(plot)
    plot.polygon.contains?(midpoint)
  end

  def southwest_rounded
    [southwest.x, southwest.y].map { |coord| format('%.6f', coord) }
  end

  def northeast_rounded
    [northeast.x, northeast.y].map { |coord| format('%.6f', coord) }
  end

  def midpoint_rounded
    [midpoint.x, midpoint.y].map { |coord| format('%.6f', coord) }
  end

  def populate_coords
    x = W3wApiService.convert_to_coordinates(w3w)
    populate_coords_from_w3w_response(x)
  end

  def populate_coords_from_w3w_response(w3w_response)
    square = w3w_response.fetch('square')
    sw = square.fetch('southwest')
    ne = square.fetch('northeast')

    self.southwest = "POINT(#{sw.fetch('lng')} #{sw.fetch('lat')})"
    self.northeast = "POINT(#{ne.fetch('lng')} #{ne.fetch('lat')})"
  end

  def sanitize_w3w
    return if w3w.blank?

    self.w3w = w3w.downcase.delete('/').squish
  end

  def viewable_by?(user)
    subscription&.user == user
  end
end
