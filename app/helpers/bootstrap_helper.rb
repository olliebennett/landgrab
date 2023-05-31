# frozen_string_literal: true

module BootstrapHelper
  def active_navlink(title, href, klass = 'nav-link')
    if current_page?(href)
      link_to title, href, class: "#{klass} active", aria: { current: 'page' }
    else
      link_to title, href, class: klass
    end
  end

  def bootstrap_alert(text, type = 'danger')
    capture do
      tag.div(class: "alert alert-#{type}", role: 'alert') do
        concat text
        concat yield if block_given?
      end
    end
  end
end
