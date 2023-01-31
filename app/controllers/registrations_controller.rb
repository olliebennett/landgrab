# frozen_string_literal: true

# Extends https://github.com/heartcombo/devise/blob/main/app/controllers/devise/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  def edit; end

  def edit_password
    set_minimum_password_length
  end

  private

  # Allow updating other attributes if replacement password is not provided
  def update_resource(resource, params)
    if params[:password].blank?
      params.delete('current_password')
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end
end
