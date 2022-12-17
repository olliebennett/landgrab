# frozen_string_literal: true

module Admin
  class PromoCodesController < ApplicationController
    before_action :check_admin

    def index
      @promo_codes = PromoCode.order(id: :desc).page(params[:page])
    end
  end
end
