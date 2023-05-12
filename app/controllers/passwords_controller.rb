# frozen_string_literal: true

# Extends https://github.com/heartcombo/devise/blob/main/app/controllers/devise/passwords_controller.rb
class PasswordsController < Devise::PasswordsController
  def after_resetting_password_path_for(_resource)
    edit_profile_path
  end
end
