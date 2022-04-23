# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: %i[show edit update]

  def index
    @subscriptions = Subscription.all
  end

  def show; end

  def edit; end

  def create
    @subscription = Subscription.new(subscription_params)
    if @subscription.save
      redirect_to subscription_url(@subscription), notice: 'Subscription was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @subscription.update(subscription_params)
      redirect_to subscription_url(@subscription), notice: 'Subscription was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_subscription
    @subscription = Subscription.find_by_hashid!(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def subscription_params
    params.require(:subscription).permit(:user_id, :block_id)
  end
end
