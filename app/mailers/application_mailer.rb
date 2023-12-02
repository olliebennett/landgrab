# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  # NOTE: If changing this, also update `config.mailer_sender` in `config/initializers/devise.rb`
  default from: "\"#{ENV.fetch('SITE_TITLE', 'Landgrab')} Support\" <#{ENV.fetch('EMAIL_FROM_ADDRESS', 'landgrab@example.com')}>".freeze

  layout 'mailer'
end
