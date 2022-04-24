# frozen_string_literal: true

class PlotsController < ApplicationController
  before_action :set_plot, only: %i[show]

  def index
    @plots = Plot.order(id: :desc).page(params[:page])
  end

  def show; end

  private

  def set_plot
    @plot = Plot.find_by_hashid!(params[:id])
  end
end
