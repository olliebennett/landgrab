# frozen_string_literal: true

module SubscriptionsHelper
  def render_subscription_price(subscription)
    return nil if subscription.price.nil?

    if subscription.recurring_interval.present?
      "#{subscription.price.format} / #{subscription.recurring_interval}"
    else
      subscription.price.format
    end
  end

  def render_subscription_status(subscription)
    return if subscription.stripe_status.nil?

    content_tag :span,
                subscription.stripe_status.humanize,
                class: "badge bg-#{subscription_class(subscription)}"
  end

  def subscription_class(subscription)
    case subscription.stripe_status
    when 'active'
      'success'
    when 'incomplete', 'incomplete_expired', 'trialing'
      'warning'
    when 'past_due', 'unpaid', 'canceled'
      'danger'
    else
      raise "Unexpected stripe status: #{subscription.stripe_status}"
    end
  end
end
