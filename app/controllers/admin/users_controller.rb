# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :check_admin
    before_action :set_user, only: %i[show]

    def index
      @users = User.all
    end

    def show; end

    private

    def set_user
      @user = User.find_by_hashid!(params[:id])
    end
  end
end
