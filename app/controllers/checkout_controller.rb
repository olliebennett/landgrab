# frozen_string_literal: true

class CheckoutController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[success cancel]
  before_action :verify_env_setup!

  STRIPE_PRICE_IDS = {
    yearly: ENV.fetch('STRIPE_PRICE_ID_BLOCK_YEARLY', nil),
    monthly: ENV.fetch('STRIPE_PRICE_ID_BLOCK_MONTHLY', nil)
  }.freeze

  def checkout
    @block = Block.find_by_hashid!(params[:block])
    create_stripe_checkout(params[:freq].to_sym)

    redirect_to @stripe_checkout.url,
                status: :see_other,
                allow_other_host: true
  end

  def success
    @block = Block.find_by_hashid!(params[:block])

    return if @block.subscription.nil?

    redirect_to block_path(@block),
                flash: { success: 'Purchase successful!' }
  end

  def cancel; end

  private

  def verify_env_setup!
    raise 'Stripe Price IDs not configured' if STRIPE_PRICE_IDS.values.any?(:nil?)
  end

  def stripe_checkout_payload(freq)
    price_id = STRIPE_PRICE_IDS.fetch(freq)
    {
      customer_email: current_user.email,
      line_items: [{
        price: price_id,
        quantity: 1
      }],
      payment_intent_data: {
        metadata: {
          user: current_user.hashid,
          blocks: @block.hashid
        }
      },
      mode: 'payment',
      success_url: checkout_success_url(block: @block.hashid),
      cancel_url: checkout_cancel_url
    }
  end

  def create_stripe_checkout(freq)
    @stripe_checkout = Stripe::Checkout::Session.create(stripe_checkout_payload(freq))
  end
end
