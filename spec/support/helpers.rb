# frozen_string_literal: true

module Helpers
  def json_fixture(filename)
    filename = "#{filename}.json" unless filename.ends_with?('.json')
    JSON.parse(file_fixture(filename).read)
  end

  def res
    JSON.parse(response.body)
  end
end
