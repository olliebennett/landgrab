# frozen_string_literal: true

module PostsHelper
  def markdown(text)
    return '-' if text.blank?

    # rubocop:disable Rails/OutputSafety
    MarkdownRenderer.render(text).html_safe
    # rubocop:enable Rails/OutputSafety
  end
end
