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

  def claim
    if user_signed_in?
      claim_hash = params[:claim_hash]
      subscr = Subscription.find_by(claim_hash:)
      if subsrc.user.present?
        if subscr.user == current_user
          redirect_to subscription_path(subscr), flash: { notice: 'All good; this subscription is already linked to your account' }
        else
          redirect_to support_path, flash: { notice: 'Oh! This subscription is already connected to a different account. Have you got two accounts? Please reach out to us and we can help.' }
        end
      else
        subscr.update!(user: current_user)
        redirect_to subscription_path(subscr), flash: { notice: 'We have successfully connected the subscription to your account' }
      end
    else
      redirect_to register_path, flash: { notice: 'Please register an account then click the link again to claim' }
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
