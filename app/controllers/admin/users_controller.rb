# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :check_admin
    before_action :set_user, only: %i[show]

    def index
      @users = User.all
      @users = @users.where('users.first_name LIKE ?', "%#{params[:first_name]}%") if params[:first_name]
      @users = @users.where('users.last_name LIKE ?', "%#{params[:last_name]}%") if params[:last_name]
      @users = @users.where('users.email LIKE ?', "%#{params[:email]}%") if params[:email]
      @users = @users.where(users: { stripe_customer_id: params[:stripe_customer_id] }) if params[:stripe_customer_id]
      @users = @users.page(params[:page])
    end

    def show; end

    private

    def set_user
      @user = User.find_by_hashid!(params[:id])
    end
  end
end
