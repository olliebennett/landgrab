# frozen_string_literal: true

module Admin
  class PlotsController < ApplicationController
    before_action :check_admin
    before_action :set_plot, only: %i[show edit update]

    def index
      @project = Project.find_by_hashid!(params[:project]) if params[:project].present?
      @plots = @project.present? ? @project.plots : Plot.all
      @plots = @plots.order(id: :desc).page(params[:page])
    end

    def show; end

    def new
      project = Project.find_by_hashid(params[:project_id]) if params[:project_id].present?
      @plot = Plot.new(project:)
    end

    def edit; end

    def create
      @plot = Plot.new(plot_params)

      respond_to do |format|
        if @plot.save
          PlotTilesPopulateJob.perform_later(@plot.id)

          format.html { redirect_to admin_plot_path(@plot), notice: 'Plot was successfully created.' }
          format.json { render :show, status: :created, location: @plot }
        else
          format.html { render :new }
          format.json { render json: @plot.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @plot.update(plot_params)
          PlotTilesPopulateJob.perform_later(@plot.id)

          format.html { redirect_to admin_plot_path(@plot), notice: 'Plot was successfully updated.' }
          format.json { render :show, status: :ok, location: @plot }
        else
          format.html { render :edit }
          format.json { render json: @plot.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def set_plot
      @plot = Plot.find_by_hashid!(params[:id])
    end

    def plot_params
      params.require(:plot).permit(:title, :description, :polygon, :project_id, :hero_image_url)
    end
  end
end
