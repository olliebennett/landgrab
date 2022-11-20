# frozen_string_literal: true

class CheckoutController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[success cancel]

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

  def extract_stripe_price_id(freq)
    case freq
    when :monthly
      ENV.fetch('STRIPE_PRICE_ID_BLOCK_MONTHLY')
    when :yearly
      ENV.fetch('STRIPE_PRICE_ID_BLOCK_YEARLY')
    else
      raise "Unhandled price frequency: #{freq}"
    end
  end

  def stripe_checkout_payload(freq)
    {
      customer_email: current_user.email,
      line_items: [{
        price: extract_stripe_price_id(freq),
        quantity: 1
      }],
      metadata: {
        user: current_user.hashid,
        blocks: @block.hashid
      },
      mode: 'subscription',
      success_url: checkout_success_url(block: @block.hashid),
      cancel_url: checkout_cancel_url
    }
  end

  def create_stripe_checkout(freq)
    @stripe_checkout = Stripe::Checkout::Session.create(stripe_checkout_payload(freq))
  end
end
