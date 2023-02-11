# frozen_string_literal: true

module Admin
  class TilesController < ApplicationController
    before_action :check_admin
    before_action :set_tile, only: %i[show]

    def index
      @plot = Plot.find_by_hashid!(params[:plot]) if params[:plot].present?
      @tiles = @plot.present? ? @plot.tiles : Tile.all
      @tiles = @tiles.where('tiles.w3w LIKE ?', "%#{params[:w3w]}%") if params[:w3w]
      case params[:subscribed]
      when 'true'
        @tiles = @tiles.joins(:subscription)
      when 'false'
        @tiles = @tiles.where.missing(:subscription)
      end
      @tiles = @tiles.order(id: :desc).includes(:plot, :subscription).page(params[:page])
    end

    def show; end

    def new
      @tile = Tile.new
    end

    def create
      @tile = Tile.new(tile_params)

      @tile.populate_coords if @tile.w3w.present?

      if @tile.save
        redirect_to admin_tile_path(@tile), notice: 'Tile was successfully created.'
      else
        render :new
      end
    end

    private

    def set_tile
      @tile = Tile.find_by_hashid!(params[:id])
    end

    def tile_params
      params.require(:tile).permit(:southwest, :northeast, :w3w)
    end
  end
end
