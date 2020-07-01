class BlocksController < ApplicationController
  before_action :set_block, only: [:show, :edit, :update, :destroy]

  def index
    @plot = Plot.find(params[:plot]) if params[:plot].present?
    if @plot.present?
      @blocks = @plot.blocks
      @center = [@plot.centroid_coords.y, @plot.centroid_coords.x]
    else
      @blocks = Block.all
      mean_x = @blocks.map { |b| b.midpoint.x }.sum / @blocks.size
      mean_y = @blocks.map { |b| b.midpoint.y }.sum / @blocks.size

      @center = [mean_y, mean_x]
    end
  end

  def show
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @block.to_geojson }
    end
  end

  def new
    @block = Block.new
  end

  def edit
  end

  def create
    @block = Block.new(block_params)

    @block.populate_coords if @block.w3w.present?

    respond_to do |format|
      if @block.save
        format.html { redirect_to @block, notice: 'Block was successfully created.' }
        format.json { render :show, status: :created, location: @block }
      else
        format.html { render :new }
        format.json { render json: @block.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @block.update(block_params)
        format.html { redirect_to @block, notice: 'Block was successfully updated.' }
        format.json { render :show, status: :ok, location: @block }
      else
        format.html { render :edit }
        format.json { render json: @block.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @block.destroy
    respond_to do |format|
      format.html { redirect_to blocks_url, notice: 'Block was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_block
    @block = Block.find(params[:id])
  end

  def block_params
    params.require(:block).permit(:southwest, :northeast, :w3w)
  end
end
