class StaticPagesController < ApplicationController
  def homepage
    if params[:center].present?
      block = Block.find_by(w3w: params[:center])
      @center = [block.midpoint.y, block.midpoint.x] if block
    end

    @center ||= [51.4778, -0.0014] # Greenwich Observatory
  end
end
