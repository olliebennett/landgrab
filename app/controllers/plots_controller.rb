class PlotsController < ApplicationController
  before_action :set_plot, only: [:show, :edit, :update, :destroy]

  def index
    @plots = Plot.all
  end

  def show
  end

  def new
    @plot = Plot.new
  end

  def edit
  end

  def create
    @plot = Plot.new(plot_params)

    respond_to do |format|
      if @plot.save
        PlotBlocksPopulateJob.perform_later(@plot.id)

        format.html { redirect_to @plot, notice: 'Plot was successfully created.' }
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
        format.html { redirect_to @plot, notice: 'Plot was successfully updated.' }
        format.json { render :show, status: :ok, location: @plot }
      else
        format.html { render :edit }
        format.json { render json: @plot.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @plot.destroy
    respond_to do |format|
      format.html { redirect_to plots_url, notice: 'Plot was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_plot
    @plot = Plot.find(params[:id])
  end

  def plot_params
    params.require(:plot).permit(:title, :polygon)
  end
end
