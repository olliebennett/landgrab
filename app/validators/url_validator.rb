# frozen_string_literal: true

# Source: https://stackoverflow.com/a/23678098/1323144
class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, options[:message] || 'must be a valid URL, starting with http:// or https://') unless url_valid?(value)
  end

  def url_valid?(url)
    uri = begin
      URI.parse(url)
    rescue StandardError
      false
    end
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  end
end
