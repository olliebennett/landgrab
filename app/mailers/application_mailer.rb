# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  FROM_EMAIL_WITH_NAME = "\"#{ENV.fetch('SITE_TITLE', 'Landgrab')} Support\" <#{ENV.fetch('EMAIL_FROM_ADDRESS', 'landgrab@example.com')}>".freeze

  default from: FROM_EMAIL_WITH_NAME

  layout 'mailer'
end
