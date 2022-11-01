# frozen_string_literal: true

# https://stackoverflow.com/a/68098687/1323144
module MarkdownRenderer
  class CustomRenderer < Redcarpet::Render::HTML
    def block_quote(quote)
      %(<blockquote class="blockquote">#{quote}</blockquote>)
    end

    def table(header, body)
      "<table class=\"table\">#{header}#{body}</table>"
    end

    def image(link, title, alt_text)
      %(<image src="#{link}" title="#{title}" alt="#{alt_text}" class="rounded img-fluid" />)
    end
  end

  def self.markdown
    # rubocop:disable Style/ClassVars
    @@markdown ||= Redcarpet::Markdown.new(
      renderer,
      autolink: true,
      fenced_code_blocks: true,
      no_intra_emphasis: true,
      space_after_headers: true,
      tables: true
    )
    # rubocop:enable Style/ClassVars
  end

  def self.renderer
    CustomRenderer.new(
      escape_html: true,
      hard_wrap: true,
      safe_links_only: true
    )
  end

  def self.render(text)
    markdown.render(text)
  end
end
