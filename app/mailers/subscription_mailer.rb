# frozen_string_literal: true

class SubscriptionMailer < ApplicationMailer
  def claim(subscription_id)
    @subscription = Subscription.find(subscription_id)

    raise 'Missing claim email from subscription!' if @subscription.claim_email.nil?

    raise 'Missing claim hash from subscription!' if @subscription.claim_hash.nil?

    mail(
      to: @subscription.claim_email,
      subject: "Claim your #{ENV.fetch('SITE_TITLE', 'LandGrab')} subscription"
    )
  end
end
