# frozen_string_literal: true

class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :homepage

  def homepage
    if params[:center].present?
      block = Block.find_by(w3w: params[:center])
      @center = [block.midpoint.y, block.midpoint.x] if block
    else
      @center = Plot::DEFAULT_COORDS
    end
  end
end
