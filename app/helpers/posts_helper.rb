# frozen_string_literal: true

module PostsHelper
  def markdown(text)
    return '-' if text.blank?

    # rubocop:disable Rails/OutputSafety
    MarkdownRenderer.render(text).html_safe
    # rubocop:enable Rails/OutputSafety
  end

  def linkify_tiles(string)
    mentioned_tiles = Post.new(body: string).mentioned_tiles

    mentioned_tiles.each do |tile|
      string.gsub!(
        %r{///(#{tile.w3w})},
        "[///\\1](#{Rails.application.routes.url_helpers.tile_url(tile)})"
      )
    end

    string
  end
end
