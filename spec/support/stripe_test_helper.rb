# frozen_string_literal: true

# Based on the Stripe Ruby SDK's own tests;
# https://github.com/stripe/stripe-ruby/blob/master/test/stripe/webhook_test.rb
module StripeTestHelper
  def stripe_generate_header(payload:)
    time = Time.zone.now
    secret = ENV.fetch('STRIPE_WEBHOOK_SIGNING_SECRET')
    signature = Stripe::Webhook::Signature.compute_signature(time, payload, secret)
    Stripe::Webhook::Signature.generate_header(time, signature)
  end
end
