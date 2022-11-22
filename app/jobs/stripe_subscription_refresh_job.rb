# frozen_string_literal: true

class StripeSubscriptionRefreshJob < ApplicationJob
  queue_as :default

  def perform(subscription)
    @subscription = subscription

    raise 'Subscription has no Stripe ID; cannot refresh!' if @subscription.stripe_id.nil?

    retrieve_subscription

    @subscription.update!(
      stripe_status: extract_status
    )
  end

  private

  def extract_status
    @stripe_sub.fetch(:status)
  end

  def retrieve_subscription
    @stripe_sub = Stripe::Subscription.retrieve(@subscription.stripe_id).to_hash
  end
end
