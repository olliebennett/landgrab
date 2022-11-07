# frozen_string_literal: true

class StripeCustomerCreateJob < ApplicationJob
  queue_as :default

  def perform(user)
    @user = user

    @user.with_lock do
      next if @user.stripe_customer_id.present?

      stripe_customer = create_customer
      @user.update!(stripe_customer_id: stripe_customer.fetch(:id))
    end
  end

  private

  def create_customer
    Stripe::Customer.create(stripe_payload).to_hash
  end

  def stripe_payload
    {
      name: @user.full_name,
      email: @user.email
    }
  end
end
