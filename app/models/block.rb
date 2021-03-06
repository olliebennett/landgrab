class Block < ApplicationRecord
  include Hashid::Rails

  after_initialize :sanitize_w3w

  belongs_to :plot, optional: true

  default_scope { order(:id) }

  validates :southwest, presence: true
  validates :northeast, presence: true

  validates :w3w, presence: true, format: { with: /\A[a-z]+\.[a-z]+\.[a-z]+\z/, message: 'format should be a.b.c' }

  auto_strip_attributes :w3w, squish: true

  def to_geojson
    geojson = RGeo::GeoJSON.encode(bounding_box.to_geometry)

    geojson['properties'] ||= {}
    geojson['properties']['popupContent'] = 'What3Words<br>' \
                                            "<a href=\"#{w3w_url}\"><code>#{w3w}</code></a><br>" \
                                            "<code>#{midpoint_rounded.join(',')}</code><br>" \
                                            "<a href=\"#{Rails.application.routes.url_helpers.block_path(self)}\">view details</a>"

    geojson.to_json
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
end
