# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def check_admin
    return if current_user&.admin?

    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end
end
