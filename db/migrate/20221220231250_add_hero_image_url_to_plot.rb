class AddHeroImageUrlToPlot < ActiveRecord::Migration[7.0]
  def change
    add_column :plots, :hero_image_url, :string
  end
end
