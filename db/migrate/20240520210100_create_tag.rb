class CreateTag < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.text :title, null: false
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
