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
end
