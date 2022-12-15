# frozen_string_literal: true

module Admin
  class SubscriptionsController < ApplicationController
    before_action :check_admin
    before_action :set_subscription, only: %i[show edit refresh update]

    def index
      @subscriptions = Subscription.all
    end

    def show; end

    def edit; end

    def create
      @subscription = Subscription.new(subscription_params)
      if @subscription.save
        redirect_to admin_subscription_url(@subscription), notice: 'Subscription was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def refresh
      StripeSubscriptionRefreshJob.perform_now(@subscription)

      redirect_to admin_subscription_url(@subscription), notice: 'Subscription status was refreshed from Stripe.'
    end

    def update
      if @subscription.update(subscription_params)
        redirect_to admin_subscription_path(@subscription), notice: 'Subscription was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_subscription
      @subscription = Subscription.find_by_hashid!(params[:id])
    end

    def subscription_params
      params.require(:subscription).permit(:user_id, :tile_id)
    end
  end
end
