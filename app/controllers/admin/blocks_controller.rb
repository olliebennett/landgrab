# frozen_string_literal: true

module Admin
  class BlocksController < ApplicationController
    before_action :check_admin
    before_action :set_block, only: %i[show]

    def index
      @plot = Plot.find_by_hashid!(params[:plot]) if params[:plot].present?
      @blocks = @plot.present? ? @plot.blocks : Block.all
      @blocks = @blocks.where('blocks.w3w LIKE ?', "%#{params[:w3w]}%") if params[:w3w]
      case params[:subscribed]
      when 'true'
        @blocks = @blocks.joins(:subscription)
      when 'false'
        @blocks = @blocks.where.missing(:subscription)
      end
      @blocks = @blocks.order(id: :desc).includes(:plot, :subscription).page(params[:page])
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

    def create
      @block = Block.new(block_params)

      @block.populate_coords if @block.w3w.present?

      respond_to do |format|
        if @block.save
          format.html { redirect_to admin_block_path(@block), notice: 'Block was successfully created.' }
          format.json { render :show, status: :created, location: @block }
        else
          format.html { render :new }
          format.json { render json: @block.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def set_block
      @block = Block.find_by_hashid!(params[:id])
    end

    def block_params
      params.require(:block).permit(:southwest, :northeast, :w3w)
    end
  end
end
