# frozen_string_literal: true

class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[about homepage explore]

  def about; end

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

    return redirect_to root_url, flash: { danger: 'No plots exist yet so nothing to explore!' } if @plot.nil?

    @available_limit = 200
    @available_blocks = @plot.blocks.available.sample(@available_limit)
    @unavailable_blocks = @plot.blocks.unavailable.distinct.sample(250 - @available_blocks.size)
  end
end
