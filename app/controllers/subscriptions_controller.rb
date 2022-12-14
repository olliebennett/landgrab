# frozen_string_literal: true

# rubocop:disable Metrics/PerceivedComplexity
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
      @subscription = Subscription.find_by_hashid(params[:id])
      if @subscription.nil?
        redirect_to support_path, flash: { danger: 'We could not find a subscription; please contact us.' }
      elsif params[:hash].blank?
        redirect_to support_path, flash: { danger: 'That link is missing something; please contact us.' }
      elsif !ActiveSupport::SecurityUtils.secure_compare(@subscription.claim_hash, params[:hash])
        redirect_to support_path, flash: { danger: "That link doesn't look quite right; please contact us." }
      elsif @subscription.user.present?
        if @subscription.user == current_user
          redirect_to subscription_path(@subscription), flash: { notice: 'All good; this subscription is already linked to your account' }
        else
          redirect_to support_path, flash: { danger: 'Oh! This subscription is already connected to a different account. Have you got two accounts? Please reach out to us and we can help.' }
        end
      else
        @subscription.update!(user: current_user)
        redirect_to subscription_path(@subscription), flash: { notice: 'We have successfully connected the subscription to your account' }
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
# rubocop:enable Metrics/PerceivedComplexity
