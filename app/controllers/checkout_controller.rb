# frozen_string_literal: true

class CheckoutController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[generate claim]

  before_action :ensure_stripe_enrollment, only: %i[checkout generate]

  before_action :set_tile, only: %i[checkout success]
  before_action :set_price, only: %i[checkout generate]

  # See docs/CHECKOUT.md
  def checkout
    create_stripe_checkout(tile: @tile)

    log_event_mixpanel('Checkout: Checkout', { authed: user_signed_in? })
    redirect_to @stripe_checkout.url,
                status: :see_other,
                allow_other_host: true
  end

  # See docs/CHECKOUT.md
  def generate
    promo_code = PromoCode.find_by!(code: params[:code]) if params[:code].present?
    err = create_stripe_checkout(promo_code:)

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

  def derive_success_url(tile)
    project = tile&.plot&.project || Project.first

    if current_user.present?
      tile.present? ? checkout_success_url(tile: tile.hashid) : welcome_project_url(project)
    else
      checkout_claim_url
    end
  end

  def stripe_checkout_payload(promo_code, tile)
    x = {
      # Stripe will create new customer if not supplied
      customer: current_user&.stripe_customer_id,
      line_items: [{
        price: @price.stripe_id,
        quantity: 1
      }],
      metadata: {
        tile: tile&.hashid
      },
      mode: 'subscription',
      success_url: derive_success_url(tile),
      cancel_url: checkout_cancel_url
    }
    if promo_code.nil?
      x[:allow_promotion_codes] = true
    else
      x[:discounts] = [{ promotion_code: promo_code&.stripe_id }]
    end
    x
  end

  def create_stripe_checkout(promo_code: nil, tile: nil)
    @stripe_checkout = Stripe::Checkout::Session.create(stripe_checkout_payload(promo_code, tile))
    nil # return no error
  rescue Stripe::InvalidRequestError => e
    raise e unless e.message == 'This promotion code cannot be redeemed because the associated customer has prior transactions.'

    # TODO: Handle when e.message.start_with?('Coupon expired')
    "You've already used this promo code so can't subscribe with this again"
  end

  def set_price
    @price = Price.find_by_hashid!(params[:price])
  end

  def set_tile
    @tile = Tile.find_by_hashid!(params[:tile]&.upcase)
  end
end
