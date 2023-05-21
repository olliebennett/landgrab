# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :check_admin
    before_action :set_user, only: %i[show]

    def index
      @users = filtered_users
      if params[:subscribed_to_plot].present?
        subscribed_to_plot_ids = params[:subscribed_to_plot].map { |x| Plot.decode_id(x) }
        @users = @users.joins(subscriptions: { tile: :plot })
                       .where(subscriptions: { stripe_status: %i[active trialing] })
                       .where(plots: { id: subscribed_to_plot_ids })
                       .distinct
      end

      respond_to do |format|
        format.html do
          @users = @users.order(id: :desc).page(params[:page])
          render :index
        end
        format.csv { render_csv('users') }
      end
    end

    def show; end

    private

    def set_user
      @user = User.find_by_hashid!(params[:id])
    end

    def filtered_users
      users = User.all
      users = users.where('users.first_name LIKE ?', "%#{params[:first_name]}%") if params[:first_name].present?
      users = users.where('users.last_name LIKE ?', "%#{params[:last_name]}%") if params[:last_name].present?
      users = users.where('users.email LIKE ?', "%#{params[:email]}%") if params[:email].present?
      users = users.where(users: { stripe_customer_id: params[:stripe_customer_id] }) if params[:stripe_customer_id].present?

      users
    end
  end
end
