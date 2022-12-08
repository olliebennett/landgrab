# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    keys = %i[first_name last_name]
    devise_parameter_sanitizer.permit(:sign_up, keys:)
    devise_parameter_sanitizer.permit(:account_update, keys:)
  end

  private

  def check_admin
    return if current_user&.admin?

    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end

  def ensure_stripe_enrollment
    return unless user_signed_in?

    return if current_user.stripe_customer_id.present?

    StripeCustomerCreateJob.perform_now(current_user)

    current_user.reload
  end
end
