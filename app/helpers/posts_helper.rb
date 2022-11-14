# frozen_string_literal: true

module PostsHelper
  def markdown(text)
    return '-' if text.blank?

    # rubocop:disable Rails/OutputSafety
    MarkdownRenderer.render(text).html_safe
    # rubocop:enable Rails/OutputSafety
  end

  def linkify_blocks(string)
    mentioned_blocks = Post.new(body: string).mentioned_blocks

    mentioned_blocks.each do |block|
      string.gsub!(
        %r{///(#{block.w3w})},
        "[///\\1](#{Rails.application.routes.url_helpers.block_url(block)})"
      )
    end

    string
  end
end
