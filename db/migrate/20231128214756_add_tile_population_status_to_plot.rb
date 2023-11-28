class AddTilePopulationStatusToPlot < ActiveRecord::Migration[7.0]
  def change
    add_column :plots, :tile_population_status, :integer, default: 0
  end
end
