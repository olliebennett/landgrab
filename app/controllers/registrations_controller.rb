# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
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
