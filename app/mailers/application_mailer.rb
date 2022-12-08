# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('EMAIL_FROM_ADDRESS', 'landgrab@example.com')
  layout 'mailer'
end
