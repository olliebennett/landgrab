# frozen_string_literal: true

module BootstrapHelper
  def active_navlink(title, href)
    if current_page?(href)
      link_to title, href, class: 'nav-link active', aria: { current: 'page' }
    else
      link_to title, href, class: 'nav-link'
    end
  end
end
