# frozen_string_literal: true

namespace :subscription do
  desc 'Refresh Stripe statuses'
  task refresh_stripe_statuses: :environment do
    Subscription.find_each do |s|
      next if s.stripe_id.nil? || s.stripe_id.start_with?('sub_fake')

      StripeSubscriptionRefreshJob.perform_later(s)
    end
  end
end
