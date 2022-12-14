class AddDescriptionToPlot < ActiveRecord::Migration[7.0]
  def change
    add_column :plots, :description, :text
  end
end
