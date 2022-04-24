# frozen_string_literal: true

module Admin
  class AdminController < ApplicationController
    before_action :check_admin

    def dashboard
      render 'admin/dashboard'
    end

    def check_admin
      return if current_user&.admin?

      render file: Rails.root.join('public/404.html'), status: :not_found, layout: false
    end
  end
end
