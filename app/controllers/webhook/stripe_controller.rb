# frozen_string_literal: true

module Webhook
  class StripeController < ApplicationController
    skip_before_action :authenticate_user!
    skip_before_action :verify_authenticity_token

    def webhook
      @event = parse_event

      case @event.type
      when 'payment_intent.succeeded'
        payment_intent_succeeded
      else
        raise "Unhandled event type: #{@event.type}"
      end

      head :ok
    end

    private

    def payment_intent_succeeded
      payment_intent = @event.data.object

      user = User.find_by_hashid!(payment_intent.metadata.user)
      block = Block.find_by_hashid(payment_intent.metadata.blocks) # TODO: Handle multiple via CSV?
      # TODO: Check block still available?

      Subscription.create(user:, block:)

      # puts 'PaymentIntent was successful!'
    end

    def parse_event
      Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError
      raise 'Invalid JSON'
    rescue Stripe::SignatureVerificationError
      raise 'Invalid signature'
    end

    def payload
      request.body.read
    end

    def sig_header
      request.headers['HTTP_STRIPE_SIGNATURE']
    end

    def endpoint_secret
      ENV.fetch('STRIPE_WEBHOOK_SIGNING_SECRET')
    end
  end
end
