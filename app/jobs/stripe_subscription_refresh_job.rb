# frozen_string_literal: true

class StripeSubscriptionRefreshJob < ApplicationJob
  queue_as :default

  def perform(subscription)
    @subscription = subscription

    raise 'Subscription has no Stripe ID; cannot refresh!' if @subscription.stripe_id.nil?

    retrieve_subscription

    @subscription.update!(
      stripe_status: extract_status,
      price_pence: extract_price_pence,
      recurring_interval: extract_recurring_interval
    )
  end

  private

  def extract_price_pence
    unit_price = @stripe_sub.fetch(:items).fetch(:data).fetch(0).fetch(:price).fetch(:unit_amount)
    quantity = @stripe_sub.fetch(:items).fetch(:data).fetch(0).fetch(:quantity)
    unit_price * quantity
  end

  def extract_recurring_interval
    @stripe_sub.fetch(:items).fetch(:data).fetch(0).fetch(:price).fetch(:recurring).fetch(:interval)
  end

  def extract_status
    @stripe_sub.fetch(:status)
  end

  def retrieve_subscription
    @stripe_sub = Stripe::Subscription.retrieve(@subscription.stripe_id).to_hash
  end
end
