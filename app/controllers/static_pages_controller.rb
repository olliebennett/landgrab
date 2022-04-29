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

  def explore
    @plot = Plot.select('plots.id, plots.title, COUNT(blocks)')
                .with_available_blocks
                .group('plots.id')
                .sample
    @available_limit = 25
    @available_blocks = @plot.blocks.available.sample(@available_limit)
    @unavailable_blocks = @plot.blocks.unavailable.distinct.sample(75)
  end
end
