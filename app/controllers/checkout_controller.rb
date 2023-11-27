# frozen_string_literal: true

class CheckoutController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[generate claim]

  before_action :ensure_stripe_enrollment, only: %i[checkout generate]

  before_action :set_tile, only: %i[checkout success]

  # See docs/CHECKOUT.md
  def checkout
    create_stripe_checkout(params[:freq].to_s, nil, @tile)

    log_event_mixpanel('Checkout: Checkout', { authed: user_signed_in? })
    redirect_to @stripe_checkout.url,
                status: :see_other,
                allow_other_host: true
  end

  # See docs/CHECKOUT.md
  def generate
    promo_code = PromoCode.find_by!(code: params[:code]) if params[:code].present?
    err = create_stripe_checkout(params[:freq].to_s, promo_code, nil)

    return redirect_to support_path, flash: { danger: err } if err.present?

    log_event_mixpanel('Checkout: Generate', { authed: user_signed_in? })
    redirect_to @stripe_checkout.url,
                status: :see_other,
                allow_other_host: true
  end

  def claim
    log_event_mixpanel('Checkout: Claim', { authed: user_signed_in? })
  end

  def success
    log_event_mixpanel('Checkout: Success', { authed: user_signed_in? })
    return if @tile.latest_subscription.nil?

    StripeSubscriptionRefreshJob.perform_later(@tile.latest_subscription)

    redirect_to tile_path(@tile),
                flash: { success: 'Purchase successful!' }
  end

  def cancel
    log_event_mixpanel('Checkout: Cancel', { authed: user_signed_in? })
  end

  private

  def extract_stripe_price_id(freq_or_hashid)
    # DEPRECATED ENV-based price IDs
    # TODO: Remove these once we've migrated to prices from database
    return ENV.fetch('STRIPE_PRICE_ID_BLOCK_MONTHLY') if freq_or_hashid == 'monthly'
    return ENV.fetch('STRIPE_PRICE_ID_BLOCK_YEARLY') if freq_or_hashid == 'yearly'
    return ENV.fetch('STRIPE_PRICE_ID_BLOCK_FIXED') if freq_or_hashid == 'fixed'

    price = Price.find_by_hashid(freq_or_hashid)

    raise "Unhandled price lookup: #{freq_or_hashid}" if price.nil?

    price.stripe_id
  end

  def derive_success_url(tile)
    project = tile&.plot&.project || Project.first

    if current_user.present?
      tile.present? ? checkout_success_url(tile: tile.hashid) : welcome_project_url(project)
    else
      checkout_claim_url
    end
  end

  def stripe_checkout_payload(freq, promo_stripe_id, tile)
    x = {
      # Stripe will create new customer if not supplied
      customer: current_user&.stripe_customer_id,
      line_items: [{
        price: extract_stripe_price_id(freq),
        quantity: 1
      }],
      metadata: {
        tile: tile&.hashid
      },
      mode: 'subscription',
      success_url: derive_success_url(tile),
      cancel_url: checkout_cancel_url
    }
    x[:discounts] = [{ promotion_code: promo_stripe_id }] if promo_stripe_id.present?
    x
  end

  def create_stripe_checkout(freq, promo_code, tile)
    @stripe_checkout = Stripe::Checkout::Session.create(stripe_checkout_payload(freq, promo_code&.stripe_id, tile))
    nil # return no error
  rescue Stripe::InvalidRequestError => e
    raise e unless e.message == 'This promotion code cannot be redeemed because the associated customer has prior transactions.'

    # TODO: Handle when e.message.start_with?('Coupon expired')
    "You've already used this promo code so can't subscribe with this again"
  end

  def set_tile
    @tile = Tile.find_by_hashid!(params[:tile]&.upcase)
  end
end
