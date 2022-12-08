# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/subscription
class SubscriptionPreview < ActionMailer::Preview
  def claim
    subscr = Subscription.where.not(claim_hash: nil).where.not(claim_email: nil).first

    SubscriptionMailer.claim(subscr.id)
  end
end
