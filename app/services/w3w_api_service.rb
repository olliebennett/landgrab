# frozen_string_literal: true

class W3wApiService
  def self.convert_to_coordinates(w3w)
    resp = api_get('convert-to-coordinates', words: w3w)
    JSON.parse(resp.body)
  end

  def self.convert_to_w3w(coords)
    resp = api_get('convert-to-3wa', coordinates: coords)
    JSON.parse(resp.body)
  end

  def self.api_base_url
    'https://api.what3words.com/v3/'
  end

  def self.api_get(path, query = {})
    uri = URI.parse(api_base_url + path)
    uri.query = query.to_query
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    req = Net::HTTP::Get.new(
      uri.request_uri,
      'Content-Type' => 'application/json',
      'X-Api-Key' => api_key
    )
    https.request(req)
  end

  def self.api_key
    ENV.fetch('WHAT3WORDS_API_KEY')
  end
end
