class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.string :hero_image_url
      t.string :logo_url

      t.timestamps
    end
  end
end
