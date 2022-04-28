# frozen_string_literal: true

module AdminHelper
  def admin_title(resource_or_model, prefix: nil, suffix: nil)
    cls = case resource_or_model
          when String
            resource_or_model
          when Class
            x = resource_or_model.model_name.human.titleize
            suffix.present? ? x : x.pluralize
          else
            hashid = resource_or_model.hashid
            resource_or_model.model_name.human.titleize
          end
    title "🕵 #{prefix} #{cls} #{hashid} #{suffix}".squish

    capture do
      concat "🕵 #{cls} #{suffix}"
      if hashid
        concat ' - '
        concat render_id(resource_or_model)
      end
    end
  end

  def render_id(obj)
    tag.code(obj.hashid, style: 'text-transform: none;')
  end
end
