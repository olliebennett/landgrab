# frozen_string_literal: true

namespace :subscription do
  desc 'Refresh Stripe statuses'
  task refresh_stripe_statuses: :environment do
    Subscription.find_each do |s|
      next if s.stripe_id.nil? || s.stripe_id.start_with?('sub_fake')

      StripeSubscriptionRefreshJob.perform_later(s)
    end
  end

  desc 'Create fake subscription for testing'
  task fake_subscription: :environment do
    n = ENV.fetch('COUNT', '3').to_i
    Tile.available.sample(n).each do |tile|
      fake_id = Array.new(8) { rand(0..9) }.join
      Subscription.create!(
        stripe_id: "sub_fake#{fake_id}",
        stripe_status: :trialing,
        tile:
      )
    end
  end
end
