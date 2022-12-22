# frozen_string_literal: true

module FiltererHelper
  # Identify whether current page has custom filter(s) applied.
  def filtered?(*also_ignore)
    filtered_params(*also_ignore)
      .present?
  end

  def filtered_params(*also_ignore)
    params
      .except(:action, :controller, :sort, :direction, :page, :utf8, :commit, :problem_id, :cols)
      .except(*also_ignore)
      .compact_blank
  end

  def render_filter_text(key, title = nil, col: 2)
    title ||= key.to_s.humanize
    label = label_tag key, title, class: 'visually-hidden'
    input = text_field_tag key, params[key], class: 'form-control', placeholder: title

    tag.div(class: "col-sm-#{col}") do
      capture do
        concat label
        concat input
      end
    end
  end

  def render_filter_enum(enum_hash, key, size: 6, col: 2, include_blank: true)
    selected_result = params[key].is_a?(Array) ? params[key] : params[key]&.split(',')
    options = enum_hash.keys
    options.unshift('BLANK') if include_blank
    input = select_tag(key, options_for_select(options, selected_result), multiple: true, size: [options.length, size].min, include_blank: '[ Stripe Status ]', class: 'form-control')

    label = label_tag key, key.to_s.titleize, class: 'visually-hidden'

    tag.div(class: "col-sm-#{col}") do
      capture do
        concat label
        concat input
      end
    end
  end

  def render_filter_submit(col: 2)
    tag.div(class: "col-sm-#{col} d-grid") do
      button_tag 'Filter', class: 'btn btn-primary btn-block'
    end
  end
end
