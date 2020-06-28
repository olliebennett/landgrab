class AddPlotToBlocks < ActiveRecord::Migration[6.0]
  def change
    add_reference :blocks, :plot, foreign_key: true
  end
end
