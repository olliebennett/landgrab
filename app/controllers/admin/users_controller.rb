# frozen_string_literal: true

module Admin
  class UsersController < Admin::AdminController
    before_action :set_user, only: %i[show edit update]

    def index
      @users = User.all
    end

    def show; end

    def edit; end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_user_url(@user), notice: 'user was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @user.update(user_params)
        redirect_to admin_user_url(@user), notice: 'user was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_user
      @user = User.find_by_hashid!(params[:id])
    end

    def user_params
      params.require(:user).permit(:user_id, :block_id)
    end
  end
end
