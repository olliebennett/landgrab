# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: %i[show]
  before_action :ensure_stripe_enrollment, only: %i[create]

  def index
    @subscriptions = current_user.subscriptions
  end

  def show; end

  def create
    @subscription = current_user.subscriptions.new(subscription_params)
    if @subscription.save
      redirect_to tile_url(@subscription.tile), notice: 'You successfully subscribed to this tile!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_subscription
    @subscription = current_user.subscriptions.find_by_hashid!(params[:id])
  end

  def subscription_params
    params.require(:subscription).permit(:tile_id)
  end
end
