class CreatePlots < ActiveRecord::Migration[6.0]
  def change
    create_table :plots do |t|
      t.string :title, null: false
      t.st_polygon :polygon, null: false

      t.timestamps
    end
  end
end
