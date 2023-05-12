# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "\"#{ENV.fetch('SITE_NAME', 'Landgrab')} Support\" <#{ENV.fetch('EMAIL_FROM_ADDRESS', 'landgrab@example.com')}>"

  layout 'mailer'
end
