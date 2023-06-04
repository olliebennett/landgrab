# frozen_string_literal: true

class StripeCustomerCreateJob < ApplicationJob
  queue_as :default

  def perform(user)
    @user = user

    @user.with_lock do
      next if @user.stripe_customer_id.present?

      # Avoid creating duplicate Stripe customers if already registered via Stripe
      stripe_customer = find_customer || create_customer
      @user.update!(stripe_customer_id: stripe_customer.fetch(:id))
    end
  end

  private

  def find_customer
    results = Stripe::Customer.search(stripe_search_payload).to_hash

    results[:data].first if results[:data].any?
  end

  def stripe_search_payload
    { query: "email:'#{@user.email}'" }
  end

  def create_customer
    Stripe::Customer.create(stripe_create_payload).to_hash
  end

  def stripe_create_payload
    {
      name: @user.full_name,
      email: @user.email
    }
  end
end
