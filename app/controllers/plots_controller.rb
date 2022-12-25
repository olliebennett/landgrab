# frozen_string_literal: true

class PlotsController < ApplicationController
  before_action :set_plot, only: %i[show]
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @plots = Plot.order(id: :desc).page(params[:page])
    log_event_mixpanel('Plots: Index', { authed: user_signed_in? })
  end

  def show
    log_event_mixpanel('Plots: Show', { authed: user_signed_in?, plot: @plot.hashid })
  end

  private

  def set_plot
    @plot = Plot.find_by_hashid!(params[:id])
  end
end
