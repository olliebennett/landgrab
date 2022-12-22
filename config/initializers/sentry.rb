# frozen_string_literal: true

sentry_dsn = ENV.fetch('SENTRY_DSN', false)
if sentry_dsn
  Sentry.init do |config|
    config.dsn = sentry_dsn
    config.breadcrumbs_logger = %i[active_support_logger http_logger]

    # Set sample rate to 1.0 to capture 100% of transactions for performance monitoring.
    # We recommend adjusting the value in production:
    # config.traces_sample_rate = 0.5
  end
end
